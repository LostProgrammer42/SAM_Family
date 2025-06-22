# PicoRV + SAM_CON Project Repository

This repository contains various architectures and configurations developed for convolution processing using the **PicoRV** RISC-V core and a custom-designed **SAM_CON** co-processor.

---

## Repository Structure

| Folder Name            | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `WASHU_2_CPU`          | A modified version of the original **WASHU2** architecture.                 |
| `Half_SAM`             | An 8-bit version of the CPU optimized for lighter compute environments.     |
| `Very_Half_SAM`        | An 8-bit Verilog-based CPU for TTO (Tiny Tapeout).                          |
| `SAM_Con`              | A 1D convolution co-processor module.                                       |
| `PicoRV_With_SAM_Con`  | Integrated version of **SAM_Con** with **PicoRV**                           |

---


##  Development Status

| Component              | Status             |
|------------------------|--------------------|
| `SAM_Con`              | ✅ Functional       |
| `PicoRV + SAM_Con`     | ✅ Integrated       |
| `WASHU_2_CPU`          | ✅ Working build    |
| `Half_SAM`             | ✅ Verified         |
| `Very_Half_SAM`        | ✅ TTO-compatible   |

---

## Authors
Stavan Mehta, Affaan Fakih, Manan Garg (The SAM Family)

The PicoRV32 used was from: https://github.com/YosysHQ/picorv32
