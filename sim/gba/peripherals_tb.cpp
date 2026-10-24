// SPDX-License-Identifier: GPL-3.0-or-later
#include "Vgba_timers_irq.h"
#include "verilated.h"
#include <iostream>
#include <stdexcept>
double sc_time_stamp(){return 0;}
int main(int argc,char**argv){
    Verilated::commandArgs(argc,argv);
    try{
        Vgba_timers_irq d;
        auto step=[&](unsigned n){for(unsigned i=0;i<n;i++){d.clk=0;d.eval();d.clk=1;d.eval();}};
        auto reset=[&](){d.ce=0;d.access=0;d.we=0;d.keys=0;d.reset=1;step(2);d.reset=0;};
        auto write=[&](unsigned a,unsigned v,unsigned mask=15){
            d.ce=0;d.addr=a;d.wdata=v;d.be=mask;d.access=1;d.we=1;step(1);d.access=0;d.we=0;d.eval();
        };
        auto read=[&](unsigned a){d.addr=a;d.eval();if(!d.selected)throw std::runtime_error("missing peripheral");return d.rdata;};
        auto check=[&](bool ok,const char*s){if(!ok)throw std::runtime_error(s);};
        for(unsigned p=0;p<4;p++){
            reset();unsigned div= p==0 ? 1 : p==1 ? 64 : p==2 ? 256 : 1024;
            write(0x100,0x00800000|(p<<16)|0xfffe);
            d.ce=1;step(div-1);check((read(0x100)&65535)==0xfffe,"prescaler early tick");
            step(1);check((read(0x100)&65535)==0xffff,"prescaler missing tick");
            step(div);check((read(0x100)&65535)==0xfffe,"timer reload");
        }
        reset();write(0x104,0x00c4ffff);write(0x108,0x00c4ffff);write(0x10c,0x00c4ffff);
        write(0x100,0x00c0fffe);write(0x200,0x78,3);write(0x208,1,1);
        d.ce=1;step(2);check(d.irq,"cascade IRQ missing");
        check(((read(0x200)>>16)&0x78)==0x78,"four timer IRQ flags");
        write(0x100,0,4);write(0x200,0x00780000,12);
        check(!d.irq && (read(0x200)>>16)==0,"IF W1C");
        reset();write(0x100,0x00801234);d.ce=1;step(1);
        write(0x100,0x5678,3);check((read(0x100)&65535)==0x1235,"reload write changed running counter");
        write(0x100,0,4);write(0x100,0x00800000,4);
        check((read(0x100)&65535)==0x5678,"restart did not reload");
        reset();write(0x200,0x1000,3);write(0x208,1,1);write(0x130,0x40010000,12);
        d.keys=1;step(1);check(d.irq,"keypad OR IRQ");
        check((read(0x130)&1023)==1022,"active-low KEYINPUT");
        write(0x200,0x10000000,8);step(2);check(!d.irq,"keypad repeated without edge");
        d.keys=0;step(1);d.keys=1;step(1);check(d.irq,"keypad retrigger");
        reset();write(0x130,0xc0030000,12);d.keys=1;step(1);
        check((read(0x200)>>16)==0,"AND keypad fired early");
        d.keys=3;step(1);check((read(0x200)>>16)==0x1000,"AND keypad missing");
        reset();d.addr=0x204;d.eval();check(!d.selected,"unimplemented WAITCNT falsely selected");
        std::cout<<"PASS timers: /1 /64 /256 /1024, four-way cascade, reload/restart/byte enables, IE/IF/IME, keypad OR/AND/retrigger\n";
    }catch(const std::exception&e){std::cerr<<"FAIL "<<e.what()<<"\n";return 1;}
}
