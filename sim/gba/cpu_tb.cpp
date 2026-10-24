// SPDX-License-Identifier: GPL-3.0-or-later
#include "Vgba_bringup.h"
#include "verilated.h"
#include <cstdint>
#include <fstream>
#include <iostream>
#include <vector>
#include <stdexcept>
double sc_time_stamp() { return 0; }

int main(int argc, char **argv) {
    Verilated::commandArgs(argc,argv);
    try {
        for (unsigned seed : {1u,17u,123u}) {
            Vgba_bringup d;
            std::vector<uint32_t> mem(0x200000,0);
            std::ifstream f("fw/gba/diagnostic.hex");
            if (!f) throw std::runtime_error("missing diagnostic.hex");
            for(unsigned i=0;i<256;i++) f >> std::hex >> mem[i];
            // Run twice with the same memory to check reset/reboot as well.
            for (unsigned run=0;run<2;run++) {
                mem[0x600000/4]=0; mem[0x640000/4]=0; mem[0x64000c/4]=0;
                bool busy=false, pending_read=false, seen_thumb=false;
                uint32_t a=0, data=0, delay=0, rng=seed;
                unsigned writes=0;
                for(unsigned cycle=0;cycle<8000000;cycle++) {
                    d.clk=0; d.reset=cycle<8; d.mem_ack=0; d.mem_rvalid=0;
                    d.eval();
                    if(!d.reset) {
                        if (busy && delay) --delay;
                        if (busy && !delay) {
                            if(pending_read) {d.mem_rvalid=1; d.mem_rdata=data; busy=false;}
                            else {
                                d.mem_ack=1;
                                if (d.mem_we) {
                                    auto &v=mem[a];
                                    for(unsigned b=0;b<4;b++) if(d.mem_be & (1<<b))
                                        v=(v & ~(255u<<(b*8))) | (d.mem_wdata & (255u<<(b*8)));
                                    if (a>=0x680000/4 && a<0x692c00/4) ++writes;
                                    busy=false;
                                } else {pending_read=true; data=mem[a]; delay=2+(rng%7);}
                            }
                        } else if (!busy && d.mem_req) {
                            busy=true;pending_read=false;a=d.mem_addr;
                            if (argc>1 && cycle<20000) std::cerr<<cycle<<" "<<(d.mem_we?"W ":"R ")<<std::hex<<(a*4)<<" "<<d.mem_wdata<<" => "<<mem[a]<<std::dec<<"\n";
                            rng=rng*1664525u+1013904223u; delay=1+(rng%11);
                        }
                    }
                    d.eval();d.clk=1;d.eval();
                    seen_thumb |= d.thumb;
                    if(d.fault) throw std::runtime_error("unexpected memory fault");
                    if(mem[0x600000/4]==0x12345678) {
                        if (!seen_thumb || d.dispcnt!=3 || mem[0x640000/4]!=12 || writes!=38400 || mem[0x640008/4]!=0x22000011 || mem[0x64000c/4]!=1)
                            throw std::runtime_error("CPU mode, SWI, condition, RAM or write count mismatch");
                        for(unsigned p=0;p<38400;p++) {
                            unsigned v=(mem[0x680000/4+p/2] >> ((p%2)*16)) & 0xffff;
                            if(v!=((31+p)&65535)) throw std::runtime_error("VRAM mismatch");
                        }
                        std::cout << "PASS seed="<<seed<<" reboot="<<run<<" clocks="<<cycle
                                  <<" ARM/Thumb/SWI/timer IRQ/SPSR/conditions/odd LDRH/IWRAM/EWRAM/38400 VRAM stores\n";
                        break;
                    }
                    if(cycle==7999999) throw std::runtime_error("CPU timeout");
                }
            }
        }
    } catch(const std::exception &e) { std::cerr << "FAIL "<<e.what()<<"\n"; return 1; }
}
