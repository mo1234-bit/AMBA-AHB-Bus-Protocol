# AMBA-AHB-Bus-Protocol
This project implements a simplified AMBA AHB (Advanced High-performance Bus) system in Verilog, featuring a master, decoder, multiplexor, and slaves. It demonstrates core AHB functionality, including burst transfers, address decoding, and response handling.

# Overview
The AMBA AHB protocol is a high-performance bus architecture for ARM-based SoCs. This implementation includes:

- AHB Master: Initiates read/write transactions and manages burst transfers.

- Decoder: Selects slaves based on address decoding.

- Slaves: Memory-backed modules handling data storage and response generation.

- Multiplexor: Routes read data and responses from slaves to the master.
  
# Features
-Burst Transfers: Supports INCR4, WRAP4, INCR8, and other burst types.

-State Machine: Master operates in IDLE, READY, WRITE, and READ states.

-Configurable Slaves: Four slaves with 32-bit memory arrays.

-Error Handling: Slaves generate OKAY/ERROR responses.

-Parameterized Design: Configurable data/address widths and slave count.

├── rtl/  
│   ├── Decoder.v        # Address decoder for slave selection  
│   ├── Master.v         # AHB Master with state machine  
│   ├── Multiplexor.v    # Data/response multiplexor  
│   ├── Slave.v          # Memory-backed AHB slave  
│   └── Top.v            # Top-level system integration  
├── doc/  
│   └── AMBA_AHB_Spec.pdf  # Protocol reference (excerpts)  
└── README.md  
