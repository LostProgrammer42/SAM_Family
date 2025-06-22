# Instruction Formats for Each Op Code
The SAM Con, uses the PicoRV PCPI interface with DMA to perform 1D convolution. It has the following 4 custom instructions. These instructions are additional to the RV32-IM ISA used by PicoRV
---

## 1. Op Code `10000` – Data Size and Kernel Size

- **31–15**: Data Size (17 bits)  
- **14–7**: Kernel Size (8 bits)  
- **6–2**: Opcode (5 bits)  
- **1–0**: Unused (2 bits)  

---

## 2. Op Code `10001` – Stride and Page Select

- **31–29**: Unused (3 bits)  
- **28–22**: Input Location 7 MSBs (7 bits)  
- **21–15**: Output Location 7 MSBs (7 bits)  
- **14–7**: Stride (8 bits)  
- **6–2**: Opcode (5 bits)  
- **1–0**: Unused (2 bits)  

---

## 3. Op Code `10010` – Output Location

- **31–7**: Output Location Remaining 25 LSBs  
- **6–2**: Opcode (5 bits)  
- **1–0**: Unused (2 bits)  

---

## 4. Op Code `10011` – Kernel + Input Data Location (also Start Signal)

- **31–7**: Input Location Remaining 25 LSBs  
- **6–2**: Opcode (5 bits)  
- **1–0**: Unused (2 bits)  

---

> **Note**: Bit positions are listed from most significant (31) to least significant (0).

## Power Consumption Analysis at 40MHz

The table below presents the power consumption figures for two configurations — one using only the **PicoRV** core, and the other using **PicoRV with SamCON** integration. Power was evaluated at two different PVT (Process, Voltage, Temperature) corners: typical conditions (`Nom_tt_025C_1v80`) and worst-case conditions (`Max_ff_n40C_1v_95`). Measurements were taken at a clock frequency of 40MHz.

| **Configuration**            | **Nom_tt_025C_1v80** | **Max_ff_n40C_1v_95** |
|-----------------------------|----------------------|------------------------|
| PicoRV                      | 9.45 mW              | 11.25 mW               |
| PicoRV + SamCON             | 10.80 mW             | 12.82 mW               |

> **Note:**  
> - `Nom_tt_025C_1v80`: Typical process, 25°C, 1.80V  
> - `Max_ff_n40C_1v_95`: Fast process corner, −40°C, 0.95V  
