# Digital-Twin-of-an-EV
MATLAB–Simulink digital twin of an electric ATV, combining real-world drive-cycle data, EV powertrain modeling, vehicle dynamics, and embedded telemetry for simulation and validation.

## Overview

This project combines a physical electric vehicle system with a virtual simulation model.

The virtual model represents the vehicle's:

- Battery
- H-Bridge inverter
- Six-phase PMSM
- Gearbox and drivetrain
- Longitudinal vehicle dynamics
- State of Charge (SOC)

Physical telemetry is acquired using an ESP32 and sensors for:

- RPM
- Voltage
- Current
- Ambient temperature
- Object temperature

The goal is to use the virtual model to simulate vehicle behavior and compare the results with physical measurements.

---

## System Architecture

```text
                 ELECTRIC VEHICLE DIGITAL TWIN
                              │
             ┌────────────────┴────────────────┐
             │                                 │
             ▼                                 ▼
      PHYSICAL SYSTEM                    VIRTUAL SYSTEM
             │                                 │
          Sensors                         Drive Cycle
             │                                 │
             ▼                                 ▼
           ESP32                       Longitudinal Driver
             │                                 │
             ▼                                 ▼
      Serial Telemetry                   PWM / Control
             │                                 │
             │                                 ▼
             │                           H-Bridge Inverter
             │                                 │
             │                                 ▼
             │                            Six-Phase PMSM
             │                                 │
             │                                 ▼
             │                       Gearbox / Drivetrain
             │                                 │
             │                                 ▼
             │                         Vehicle Dynamics
             │                                 │
             │                         ┌───────┴───────┐
             │                         ▼               ▼
             │                       Speed         Battery/SOC
             │                         │
             └──────────────► Validation ◄────────────┘
```

For a detailed explanation of the system architecture, see:

[`docs/architecture.md`](docs/architecture.md)

---

## Key Components

### Virtual Simulation

The MATLAB/Simulink model represents the main longitudinal powertrain:

```text
Drive Cycle
     │
     ▼
Longitudinal Driver
     │
     ▼
PWM / Control
     │
     ▼
H-Bridge Inverter
     │
     ▼
Six-Phase PMSM
     │
     ▼
Gearbox / Drivetrain
     │
     ▼
Vehicle Dynamics
     │
     ▼
Vehicle Speed
```

The model also calculates vehicle distance and battery SOC.

### Physical Data Acquisition

An ESP32 is used to collect physical system telemetry.

```text
RPM Sensor ──────────┐
                     │
MLX90614 ────────────┤
                     ▼
                   ESP32
                     ▲
INA219 ──────────────┘
                     │
                     ▼
              Serial Telemetry
```

---

## Hardware

* ESP32
* INA219 current/voltage sensor
* MLX90614 temperature sensor
* RPM sensor
* Electric vehicle powertrain hardware

## Software

* MATLAB
* Simulink
* Arduino IDE
* Embedded C/C++ for ESP32

---

## Repository Structure

```text
electric-vehicle-digital-twin/
│
├── README.md
├── .gitignore
├── LICENSE
│
├── matlab/
│   ├── parameters/
│   ├── drive_cycle/
│   ├── vehicle_dynamics/
│   ├── battery/
│   ├── motor/
│   ├── control/
│   └── validation/
│
├── embedded/
│   └── esp32/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── example/
│
├── results/
│   └── figures/
│
└── docs/
    ├── architecture.md
    └── screenshots/
```

---

## Project Parameters

| Parameter                      |  Value |
| ------------------------------ | -----: |
| Vehicle mass                   | 230 kg |
| Wheel radius                   | 0.25 m |
| Drag coefficient               |    0.3 |
| Frontal area                   | 1.2 m² |
| Rolling resistance coefficient |  0.015 |
| Gear ratio                     |    6.5 |
| Drivetrain efficiency          |    90% |
| Battery nominal voltage        | 51.6 V |
| Battery capacity               | 120 Ah |
| Initial SOC                    |   100% |
| Simulation sample time         | 0.01 s |

---

## Validation

The virtual model is intended to be compared against physical vehicle measurements and recorded vehicle data.

The project considers parameters such as:

* Vehicle speed
* SOC
* Distance
* Torque
* Battery behavior

The project documentation reports deviations in the approximate range of 3–9% for key parameters.

---

## Current Implementation

The repository currently contains:

* Vehicle parameter definitions
* Drive-cycle loading
* Longitudinal vehicle dynamics
* Battery SOC calculation
* Battery voltage estimation
* PMSM/powertrain interfaces
* Longitudinal control interface
* ESP32 telemetry firmware
* Simulation documentation
* System architecture documentation

---

## Future Work

Potential extensions include:

* Regenerative braking
* Thermal management
* Machine-learning-based prediction
* Cloud monitoring
* Hardware-in-the-loop testing

---

## Author

Nikita Gashiganti

B.Tech — Electronics & Communication Engineering

