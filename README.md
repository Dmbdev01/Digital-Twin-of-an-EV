# Digital-Twin-of-an-EV
MATLAB–Simulink digital twin of an electric ATV, combining real-world drive-cycle data, EV powertrain modeling, vehicle dynamics, and embedded telemetry for simulation and validation.


## Project Preview

<p align="center">
  <img src="docs/screenshots/simulink-model.png" width="850">
</p>

<p align="center">
  <img src="docs/screenshots/vehicle-hardware.png" width="650">
  <img src="docs/screenshots/voltage-vs-soc.png" width="650">
</p>

---

### Overview

This project explores how a physical electric vehicle can be represented using a virtual model.

The simulation takes **real speed data recorded from the physical vehicle** and uses it as the reference drive cycle. The virtual powertrain then models the battery, inverter, motor, drivetrain, and vehicle dynamics to reproduce the vehicle's behavior in simulation.

At the same time, an ESP32-based setup is used to collect physical measurements such as **RPM, voltage, current, and temperature** for analysis and validation.

The overall idea is simple:

```text
Physical Vehicle
       │
       │ Measurements
       ▼
   Real-World Data
       │
       ▼
 MATLAB / Simulink
       │
       ├── Battery
       ├── Inverter
       ├── PMSM
       ├── Drivetrain
       └── Vehicle Dynamics
       │
       ▼
 Simulation Results
       │
       ▼
   Validation
