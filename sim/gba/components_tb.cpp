// SPDX-License-Identifier: GPL-3.0-or-later
#include "Vgba_components.h"
#include "verilated.h"
#include <iostream>
#include <stdexcept>
#include <cstdint>
double sc_time_stamp() { return 0; }
static uint32_t pixel(unsigned p) {return ((p*37) ^ (p>>3)) & 32767;}
static uint32_t expand(unsigned p) {
    unsigned c=pixel(p),r=c&31,g=(c>>5)&31,b=(c>>10)&31;
    return (((r<<3)|(r>>2))<<16)|(((g<<3)|(g>>2))<<8)|((b<<3)|(b>>2));
}
static uint32_t read_word(unsigned a) {
    if (a>=0x1a0000 && a<0x1a4b00) {
        unsigned p=(a-0x1a0000)*2;
        return pixel(p)|(pixel(p+1)<<16);
    }
    return a ^ 0xa55a1234u;
}
int main(int argc,char **argv) {
    Verilated::commandArgs(argc,argv);
    try {
        Vgba_components d;
        struct Map {uint32_t a,p;bool m,b,i,r;};
        const Map cases[]={
            {0,0,1,1,0,1},{0x3fff,0,1,1,0,1},{0x4000,0,0,0,0,1},
            {0x02000000,0x600000,1,0,0,0},{0x0207ffff,0x63ffff,1,0,0,0},
            {0x03018004,0x640004,1,0,0,0},{0x040003ff,0,1,0,1,0},
            {0x04000400,0,0,0,0,0},{0x05000401,0x660001,1,0,0,0},
            {0x06018002,0x690002,1,0,0,0},{0x06038002,0x690002,1,0,0,0},
            {0x07000c01,0x660401,1,0,0,0},{0x085fffff,0x5fffff,1,0,0,1},
            {0x08600000,0x600000,0,0,0,1},{0x0a000010,0x10,1,0,0,1},
            {0x0c000010,0x10,1,0,0,1},{0x0e010001,0x650001,1,0,0,0},
            {0x10000000,0,0,0,0,0}};
        for(auto c:cases) {
            d.addr=c.a;d.eval();
            if(d.physical!=c.p || d.mapped!=c.m || d.bios!=c.b || d.io!=c.i || d.readonly!=c.r)
                throw std::runtime_error("memory map mismatch at "+std::to_string(c.a));
        }
        std::cout<<"PASS address decode: "<<sizeof(cases)/sizeof(cases[0])<<" boundary/mirror/overflow cases\n";
        for(unsigned run=0;run<2;run++) {
            d.reset=1;d.vreset=1;d.enable=1;d.clk=0;d.vclk=0;
            d.cpu_req=0;d.lp_ack=0;d.lp_rvalid=0;d.cx=0;d.cy=0;d.eval();
            for(int i=0;i<8;i++){d.clk=1;d.vclk=1;d.eval();d.clk=0;d.vclk=0;d.eval();}
            d.reset=0;d.vreset=0;d.cpu_req=1;d.cpu_we=0;d.cpu_addr=0x170000;d.cpu_be=15;
            bool busy=false,returning=false;unsigned delay=0,a=0;
            unsigned x=0,y=0,frame=0,pixels=0,cpu_reads=0;
            for(uint64_t t=0;frame<3;t++) {
                if(t%8==0) {
                    d.clk=0;d.lp_ack=0;d.lp_rvalid=0;d.eval();
                    if(busy && delay) --delay;
                    if(busy && !delay) {
                        if(returning){d.lp_rvalid=1;d.lp_rdata=read_word(a);busy=false;}
                        else {d.lp_ack=1;returning=true;delay=2;}
                    } else if(!busy && d.lp_req) {busy=true;returning=false;delay=2;a=d.lp_addr;}
                    d.eval();
                    bool ack=d.cpu_ack;
                    if(d.cpu_rvalid) {
                        if(d.lp_rdata!=read_word(d.cpu_addr-1)) throw std::runtime_error("read owner mismatch");
                        ++cpu_reads;
                    }
                    d.clk=1;d.eval();
                    if(ack) d.cpu_addr++;
                }
                if(t%10==0) {
                    d.vclk=0;d.cx=x;d.cy=y;d.eval();
                    // RGB present before the edge is what the HDMI encoder samples.
                    if(frame>=1 && x<720 && y<480) {
                        uint32_t expected=expand((y/3)*240+x/3);
                        if(d.rgb!=expected) {
                            std::cerr<<"pixel "<<x<<","<<y<<" got "<<std::hex<<d.rgb<<" expected "<<expected<<std::dec<<"\n";
                            throw std::runtime_error("HDMI RGB555 3x mismatch");
                        }
                        ++pixels;
                    }
                    d.vclk=1;d.eval();
                    if(++x==858){x=0;if(++y==525){y=0;frame++;}}
                }
            }
            if(d.underrun || cpu_reads<1000 || pixels!=691200) throw std::runtime_error("underrun, starvation or coverage failure");
            std::cout<<"PASS reboot="<<run<<" 691200 HDMI pixels, 3x RGB555, dual clocks, "<<cpu_reads<<" competing CPU reads, no underrun\n";
        }
    }catch(const std::exception&e){std::cerr<<"FAIL "<<e.what()<<"\n";return 1;}
}
