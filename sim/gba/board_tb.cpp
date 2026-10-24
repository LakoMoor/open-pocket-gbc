// SPDX-License-Identifier: GPL-3.0-or-later
#include "Vgba_board_sim.h"
#include "verilated.h"
#include <iostream>
#include <fstream>
#include <memory>
#include <stdexcept>
double sc_time_stamp() { return 0; }
static uint32_t expand(unsigned p) {
    unsigned c=(p+31)&32767,r=c&31,g=(c>>5)&31,b=(c>>10)&31;
    return (((r<<3)|(r>>2))<<16)|(((g<<3)|(g>>2))<<8)|((b<<3)|(b>>2));
}
int main(int argc,char **argv) {
    try {
        auto context=std::make_unique<VerilatedContext>();
        context->commandArgs(argc,argv);
        auto d=std::make_unique<Vgba_board_sim>(context.get());
        d->s1=0;d->eval();
        bool previous_clk=false,capture=false;
        unsigned frames=0,pixels=0,boots=0;
        uint64_t release_button_at=0;
        std::ofstream ppm("build/gba/diagnostic.ppm",std::ios::binary);
        ppm<<"P6\n720 480\n255\n";
        while(context->time()<300000000000ULL) { // 300 ms, picosecond timescale
            if(!d->eventsPending()) throw std::runtime_error("simulation stopped");
            // The scanout's next-pixel value is sampled by HDMI at this edge.
            auto rgb=d->rgb;auto x=d->cx;auto y=d->cy;
            context->time(d->nextTimeSlot());d->eval();
            if(release_button_at && context->time()>=release_button_at){d->s1=0;release_button_at=0;d->eval();}
            if(d->fault) throw std::runtime_error("board memory fault");
            if(d->vid_clk && !previous_clk) {
                if(d->done && x==0 && y==0) {
                    if (++frames==2) capture=true;
                    else if(frames==3) {
                        if(pixels!=345600 || d->underrun) throw std::runtime_error("board coverage or underrun");
                        if(++boots==2) break;
                        d->s1=1;d->eval();release_button_at=context->time()+1000000;
                        frames=0;pixels=0;capture=false;
                    }
                }
                if(capture && x<720 && y<480) {
                    if(rgb!=expand((y/3)*240+x/3)) {
                        std::cerr<<"board pixel "<<x<<","<<y<<" got "<<std::hex<<rgb<<" expected "<<expand((y/3)*240+x/3)<<"\n";
                        throw std::runtime_error("board HDMI pixel mismatch");
                    }
                    char c[3]={char(rgb>>16),char(rgb>>8),char(rgb)};
                    if(boots==0) ppm.write(c,3);
                    ++pixels;
                }
            }
            previous_clk=d->vid_clk;
        }
        if(boots!=2 || pixels!=345600 || d->underrun) throw std::runtime_error("board timeout or scanout underrun");
        std::cout<<"PASS gba_top: boot loader + real sdram_ctrl + SDRAM pin model + CPU homebrew + 691200 HDMI RGB pixels across two board boots; "
                 <<context->time()/1000000<<" us simulated\n";
    } catch(const std::exception&e){std::cerr<<"FAIL "<<e.what()<<"\n";return 1;}
}
