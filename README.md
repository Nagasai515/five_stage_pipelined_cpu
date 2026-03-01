# 5-Stage RV32I Pipelined Processor

A modular and synthesizable 5-stage in-order RISC-V (RV32I) processor implemented in Verilog HDL.  
The design includes complete pipeline control with hazard handling and is functionally verified through simulation.

## Architecture
- 5-stage pipeline: IF, ID, EX, MEM, WB  
- In-order execution model  
- Separate control and datapath design  
- Modular RTL structure for easy scalability  

## Features
- RV32I Base Integer Instruction Set
- Hazard Detection Unit for data hazards
- Forwarding (bypass) paths to minimize stalls
- Stall and Flush Control Logic
- Data and Control Hazard handling
- Functionally verified using waveform simulation

## Verification
- Directed testbench-based validation
- Pipeline hazard scenarios tested
- Forwarding and stall conditions verified
- Simulation performed using Vivado

## Tools
- Verilog HDL
- Xilinx Vivado (Simulation)
- Ubuntu 24.04
- Git for version control

## Future Work
- Branch prediction enhancement
- Performance benchmarking
- ASIC synthesis using OpenLane (Sky130)
- Area, Timing, and Power analysis
- Physical design flow integration

## Author
Naga Sai Krishna

## License
MIT License
