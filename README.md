# LoadSense: FPGA-Accelerated Edge AI for Real-Time Peak Demand Shaving

<div align="center">
  <img src="https://img.shields.io/badge/FPGA-Verilog-blue?style=flat-square&logo=c" alt="Verilog RTL" />
  <img src="https://img.shields.io/badge/Machine%20Learning-Python-blue?logo=python&logoColor=white&style=flat-square" alt="Python ML" />
  <img src="https://img.shields.io/badge/Status-Active-success.svg?style=flat-square" alt="Status" />
</div>

**LoadSense** is an Edge AI-driven smart energy controller implemented entirely on an FPGA. It provides real-time peak load detection and automated peak shaving mitigation at the edge, effectively circumventing demand-charge tariffs and power grid stress. 

By analyzing real-time global active power trends from a sliding window of historical consumption data, a robust Multi-Layer Perceptron (MLP) accurately predicts imminent power peaks. Upon detection, a hardware-based Peak Shaving Controller dynamically mitigates the peak using a user-configurable, sub-millisecond priority switching system—without ever relying on laggy, cloud-based architectures.

## 🌟 Key Features

- **Real-Time Edge AI Logic:** Neural network inference (MLP) deployed strictly on FPGA hardware logic, ensuring completely deterministic, microsecond-level latency control.
- **Priority-Based Dynamic Load Shedding:** Evaluates user-assigned load priorities and conditionally turns off or reschedules non-critical machines (e.g., Washers, EVs) while maintaining constant power to critical systems (e.g., Medical Equipment, Refrigerators).
- **Seamless Renewable Auto-Switching:** Includes strategies to instantly disconnect heavy grid loads and push them perfectly over to alternative renewable energy systems (solar or battery storage) without breaking power supply.
- **Resource-Optimized Hardware Co-Design:** Built around a time-multiplexed, single-multiplier MAC (Multiply-Accumulate) engine on the RTL to deeply minimize DSP footprint. It employs Q4.12 fixed-point math and a pure 8-bit LUT-based Tanh approximation for blazing fast activations.

## 📖 Problem Statement

Modern power architectures in residential or commercial complexes frequently suffer from unpredictable demand spikes when multiple high-load appliances operate simultaneously. This drives up utility bills and destabilizes energy grids. 

Reactive threshold-breaking solutions often act *after* the peak is recorded. Alternatively, complex cloud-based deep learning methods force private residential telemetry onto continuous data streams over inherently unstable ISP lines. LoadSense provides local, pre-emptive ML prediction fused directly with bare-metal relay actuation. 

## 🛠️ System Architecture

The project unites sophisticated model development with uncompromised, bare-metal hardware execution:

1. **Python Data Pipeline (`main.ipynb`):** A sequence processing the *UCI Household Power Consumption* dataset using manual minority-class oversampling to emphasize tracking the 85th-percentile critical load events.
2. **Neural Network Hardware Engine (`mlp_16_4_2_1` module):** A 16-4-2-1 fully connected structure synthesized into Verilog `Q4.12` arrays, predicting whether the very next active power timestep will break the threshold.
3. **Hardware Peak Shaving Controller (`peak_shaving_controller` module):** Directly executes upon the inference assertion flag, cutting GPIO enable pins matching out low-priority sockets, or launching timer-based rescheduling routines.

## 📂 Repository Structure

- `LoadSense_Technical_Report.md`: Full technical publication abstract outlining system viability, datasets, equations, logic synthesis footprint, and novelty factors.
- `LoadSense_description.txt`: The foundational design document and architectural spec for the overall framework.
- `main.ipynb`: A Python/Jupyter Notebook used to load and sanitize data (`Data/`), instantiate Scikit-Learn `MLPClassifier`, optimize predictive thresholds, balance classes, train the algorithm, and cleanly print the network weights directly formatted for Verilog arrays.
- `Verilog.v`: The principal RTL implementation containing all synthesis modules: 
  - `loadsense_top`: Overall design wrapper.
  - `tanh_lut`: Dedicated hyperbolic tangent ROM table.
  - `mlp_16_4_2_1` / `peak_shaving_controller`: The core ML inference and load-switching State Machines.
- `Data/`: Directory originally intended for `.txt`/`.csv` historical electrical metrics. 

## 📊 Performance & Results

- **Predictive Accuracy:** Achieves **~96.95% accuracy** on the comprehensive test subset.
- **Spike Detection (Recall):** Leverages aggressive class balancing to detect an impressive **93% of all impending load spikes** (Class 1 Recall). 
- **Latency Control:** Full multi-layer inference cycle spans only a minimal set of FSM clock ticks, vastly outperforming software microcontrollers and achieving microsecond response readiness.

## 🚀 Getting Started

1. **Model Regeneration:** Run `main.ipynb` to parse your data inside `Data/`, tune neural dimensions, and serialize Verilog-compliant `w1`, `b1`, `w2`, etc. weight matrices.
2. **Setup FPGA Synthesizer:** Create a new project in Xilinx Vivado or Intel Quartus. Import `Verilog.v` as your top module. Paste the regenerated weight offsets inside the `initial` block of `mlp_16_4_2_1`. 
3. **I/O Mapping and Synthesis:** Map `grid_power_en[3:0]` and `alt_power_en[3:0]` wires strictly to exterior PMODs or I/O pins connected to your Solid State Relays (SSR). Synthesize, route, and program device. 
