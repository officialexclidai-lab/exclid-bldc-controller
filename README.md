# Exclid Semiconductor - BLDC Motor Controller

## Status: RTL Development + FPGA Prototype Phase
**Team:** 2 people (Founder + Technical Co-founder)
**Location:** Kharagpur, West Bengal

## Architecture
- PWM: 8-bit, 255-cycle
- Commutation: 6-step hall-sensor
- Protection: Overcurrent with fault output
- Soft-start: Rate-limited throttle

## Files

### RTL Design
- `src/rtl/bldc_motor_controller.v` - Core chip logic (129 lines)
- `src/testbench/tb_bldc_motor_controller.v` - Simulation testbench

### FPGA Demo
- `fpga/fpga_top.v` - Top-level wrapper for real hardware
- `fpga/basys3_constraints.xdc` - Digilent Basys 3 / Arty A7 pin constraints
- `fpga/ecp5_constraints.ldc` - Lattice ECP5 / ULX3S pin constraints
- `fpga/scripts/build_basys3.tcl` - Vivado build script
- `fpga/Makefile` - Build targets for both Xilinx and Lattice

## Toolchain (Free)
- Icarus Verilog (simulation)
- Yosys (synthesis)
- OpenLane (physical design)
- SkyWater 130nm PDK (free)
- Vivado WebPACK (free for Artix-7) or nextpnr (free for ECP5)

## Quick Start

### Simulation
```bash
cd src
iverilog -g2012 -o bldc_sim.out rtl/bldc_motor_controller.v testbench/tb_bldc_motor_controller.v
vvp bldc_sim.out
gtkwave bldc_testbench.vcd
```

### FPGA Build (Xilinx)
```bash
cd fpga
vivado -mode batch -source scripts/build_basys3.tcl
```

### FPGA Build (Lattice ECP5 - Open Source)
```bash
cd fpga
make lattice
```

## Demo Setup
1. Program FPGA board with bitstream
2. Connect SW[2:0] to simulate hall sensor states
3. Set SW[15:8] for throttle (0-255)
4. Press BTNC to reset
5. Press BTNU to trigger overcurrent
6. LEDs show phase driver outputs
7. Connect PMOD headers to external motor driver (e.g., DRV8301)

## Target
- OpenMPW tape-out (Q4 2026)
- FPGA prototype validation with real EV motor

## License
Apache 2.0