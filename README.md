# Exclid Semiconductor - BLDC Motor Controller

Open-source BLDC motor controller RTL designed for ASIC implementation in SkyWater 130nm using the OpenLane flow.

## Overview

This project is a digital BLDC motor controller core developed as an early semiconductor proof-of-work for Exclid Semiconductor. It includes Verilog RTL, a simulation testbench, FPGA-oriented integration files, and a completed RTL-to-GDSII implementation using open-source EDA tools.

The design was taken through functional verification, synthesis, place-and-route, signoff timing analysis, and final GDS generation. The final cleaned rerun removed the earlier fanout issue and reported zero max fanout, max slew, and max capacitance violations.

## Features

- 8-bit PWM generation for motor drive control
- 6-step Hall-sensor commutation logic
- Soft-start throttle behavior
- Overcurrent protection and fault signaling
- Verilog RTL with simulation testbench
- OpenLane Sky130 physical design flow
- Final GDSII layout generated successfully

## Project Structure

```text
.
├── README.md
├── RESULTS_SUMMARY.txt
├── src/
│   ├── rtl/
│   │   └── bldc_motor_controller.v
│   └── testbench/
│       └── tb_bldc_motor_controller.v
├── fpga/
├── docs/
│   └── images/
│       ├── gtkwave-waveform.jpg
│       └── klayout-layout.jpg
└── openlane/
```

## Tools Used

- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys
- OpenLane
- SkyWater SKY130 PDK
- KLayout

## Functional Overview

The controller accepts Hall sensor inputs and throttle input, then produces phase driver outputs for BLDC commutation. It also monitors overcurrent behavior and raises a fault signal when required.

At the simulation level, the waveform demonstrates clock activity, Hall state transitions, throttle input behavior, phase driver updates, and fault-related signals. At the physical-design level, the same RTL was synthesized and converted into a final GDS layout.

## Results

- RTL simulation completed successfully
- GTKWave waveform captured for core control signals
- OpenLane flow completed successfully
- Final GDS generated
- Positive timing slack reported
- Max fanout violation count: 0
- Max slew violation count: 0
- Max cap violation count: 0
- Earlier successful run reported no final DRC violations and no setup/hold violations

## Screenshots

### GTKWave simulation waveform

The waveform below shows the BLDC controller simulation in GTKWave, including the Hall sensor sequence, phase driver response, reset, throttle, overcurrent, and fault-related signals.



### KLayout physical layout

The image below shows the final GDS layout of the `bldc_motor_controller` generated through the OpenLane Sky130 physical design flow.



## How to Run Simulation

From the project folder, compile and run the testbench:

```bash
iverilog -g2012 -o bldc_sim.out src/rtl/bldc_motor_controller.v src/testbench/tb_bldc_motor_controller.v
vvp bldc_sim.out
gtkwave bldc_testbench.vcd
```

This opens the waveform viewer so the key signals can be inspected visually.

## How to Run OpenLane

Place the design files and configuration in your OpenLane design directory, then run:

```bash
./flow.tcl -design bldc_motor_controller
```

For the cleaned final run, use the rerun tag that includes the fanout fix configuration.

## Key Output Files

- `bldc_motor_controller.gds`
- `31-rcx_sta.checks.rpt`
- `metrics.csv`
- `manufacturability.rpt`
- `bldc_motor_controller.v`
- `tb_bldc_motor_controller.v`

## GitHub Upload Guide

If uploading manually through the GitHub web interface:

1. Create the repository.
2. Upload `README.md`.
3. Upload the waveform screenshot as `docs/images/gtkwave-waveform.jpg`.
4. Upload the KLayout screenshot as `docs/images/klayout-layout.jpg`.
5. Upload the key reports and source files.
6. Confirm that the README preview renders both images correctly.

## Status

This project demonstrates a complete open-source ASIC flow for a BLDC motor controller, from RTL design and verification to physical layout generation.

It serves as a strong semiconductor portfolio project because it includes both functional proof and physical-design proof.

## License

Apache 2.0
