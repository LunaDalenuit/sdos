# **S**imple **D**isk **O**perating **S**ystem

**SDOS** is a simple, bare-metal, 16-bit real mode operating system written from scratch in 8088 Assembly (x86 NASM),
targeting the original IBM Personal Computer (IBM-5150).

## License

    ==============================================================================
                                    SDOS v1.0
                        Simple Disk Operating System
                        Copyright (C) 2026 SDOS Authors
    ==============================================================================

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, and distribute copies of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

## Rules

**SDOS** is an operating system that's always 45 years in the past, meaning when developing it, I **cannot** use newer hardware, systems, CPUs, etc.

For example; the 80386 (i386) processor was released on October 17th, 1985,
meaning I cannot use it until October 17th, 2030.

As of August 19th, 2026 (1981), the limitations follow:

* **Processor:** Intel 8088 @ 4.77MHz (Strictly 16-bit real mode; no 801/2/386 instructions allowed).
* **Memory:** 64KiB (~65.5KB) base RAM limit.
* **Storage Standard:** 160KiB 5.25-inch Single-Sided Double Density (SSDD) Floppy Disk (40 tracks, 8 sectors/track, 512 bytes/sector).
* **Display Output:** IBM Color Graphics Adapter (CGA) / 80x25 text mode (Mode 3).
* **Emulation Hardware:** Cycle-accurate execution via 86Box v6.0+ emulating an authentic IBM PC 5150 motherboard. Modern hypervisors (QEMU, VirtualBox) are explicitly prohibited.

However it is not just 45-years behind in code, but also in the system itself.
All dates must be represented 45 years prior. If you want to note the current date, you must do so by substracting the year by 45.

## Building

Required build tools:

* Any GNU/Linux system.
* Netwide Assembler `nasm`

Optionally:

* 86Box `86Box` if you want to emulate **SDOS**.

Like most of my other projects; In the project root, simply run `make` and a floppy image file will be generated in `./build`. Alternatively, `make run` can be used to emulate **SDOS** using 86Box.
