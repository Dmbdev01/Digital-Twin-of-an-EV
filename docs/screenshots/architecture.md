Yep. Here is the **clean, complete `docs/architecture.md`** using exactly those 10 sections and the subsections you listed. You can paste the whole thing directly into GitHub.

````markdown
# Electric Vehicle Digital Twin — System Architecture

## 1. Overview

This project develops a digital twin of an electric vehicle using MATLAB/Simulink and physical sensor data.

The system combines a physical electric vehicle with a virtual simulation model. The physical system provides measured operating data, while the virtual system represents the vehicle powertrain and longitudinal dynamics.

The main objective is to simulate vehicle behavior, analyze energy and performance, and compare simulated results with physical measurements.

The digital twin consists of two primary layers:

- **Physical System** — vehicle hardware, sensors, and ESP32-based data acquisition.
- **Virtual System** — MATLAB/Simulink models representing the battery, inverter, PMSM, drivetrain, and vehicle dynamics.

---

## 2. Overall System Architecture

```text
                    ELECTRIC VEHICLE DIGITAL TWIN
                              │
             ┌────────────────┴────────────────┐
             │                                 │
             ▼                                 ▼
      PHYSICAL SYSTEM                    VIRTUAL SYSTEM
             │                                 │
             ▼                                 ▼
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
             │                            PMSM Motor
             │                                 │
             │                                 ▼
             │                       Gearbox / Drivetrain
             │                                 │
             │                                 ▼
             │                         Vehicle Dynamics
             │                                 │
             │                         ┌───────┴───────┐
             │                         │               │
             │                         ▼               ▼
             │                       Speed         Distance
             │                         │
             │                         ▼
             │                        SOC
             │                         │
             └──────────────► VALIDATION ◄─────────────┘
````

The physical and virtual systems are connected through measured data and validation.

---

## 3. Physical System

The physical layer consists of the electric vehicle hardware and the sensors used to monitor its operating condition.

The physical system provides measurements that can be used to analyze and validate the virtual model.

The measured parameters include:

* RPM
* Voltage
* Current
* Ambient temperature
* Object temperature

The main physical components involved in data acquisition are:

* ESP32
* INA219 current/voltage sensor
* MLX90614 temperature sensor
* RPM sensor

```text
                PHYSICAL ELECTRIC VEHICLE
                          │
             ┌────────────┼────────────┐
             │            │            │
             ▼            ▼            ▼
           Motor        Battery      Sensors
                                      │
                     ┌────────────────┼──────────────┐
                     │                │              │
                     ▼                ▼              ▼
                    RPM            Voltage/Current  Temperature
                     │                │              │
                     └────────────────┴──────────────┘
                                      │
                                      ▼
                                    ESP32
```

---

## 4. ESP32 Data Acquisition

The ESP32 is used to acquire telemetry from the physical system.

The current firmware measures and outputs:

| Parameter           | Acquisition Method          |
| ------------------- | --------------------------- |
| RPM                 | Pulse input using interrupt |
| Ambient temperature | MLX90614                    |
| Object temperature  | MLX90614                    |
| Voltage             | INA219                      |
| Current             | INA219                      |

The ESP32 transmits the measurements through a serial connection.

### Serial Configuration

* **Baud rate:** `115200`
* **Telemetry interval:** `500 ms`

The RPM sensor is connected to an interrupt-capable input. The time interval between successive pulses is measured and used to calculate RPM.

```text
RPM Sensor
    │
    ▼
ESP32 GPIO
    │
    ▼
Interrupt
    │
    ▼
Pulse Interval
    │
    ▼
RPM Calculation
    │
    └──────────────┐
                   │
MLX90614 ──────────┤
                   │
INA219 ────────────┤
                   ▼
                 ESP32
                   │
                   ▼
             Serial Telemetry
```

The telemetry format used by the firmware is:

```text
RPM, AmbientTemp(C), ObjectTemp(C), Voltage(V), Current(mA)
```

---

## 5. Virtual Simulation

The virtual system is implemented using MATLAB/Simulink.

The simulation represents the major components and interactions of the electric vehicle powertrain.

The virtual system receives a reference vehicle speed from a custom drive cycle and calculates the resulting vehicle behavior through the powertrain and vehicle dynamics.

```text
                 VIRTUAL ELECTRIC VEHICLE
                          │
                          ▼
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
                     PMSM Motor
                          │
                          ▼
                Gearbox / Drivetrain
                          │
                          ▼
                  Vehicle Dynamics
                          │
              ┌───────────┼───────────┐
              │           │           │
              ▼           ▼           ▼
            Speed      Distance       SOC
              │
              ▼
       Speed Feedback
              │
              └──────────► Longitudinal Driver
```

The virtual simulation allows the behavior of the electric vehicle to be studied without requiring every operating condition to be physically reproduced.

---

## 6. Virtual Powertrain

The virtual powertrain represents the main energy and mechanical flow from the battery to the vehicle motion.

```text
Battery
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
Vehicle Wheels
   │
   ▼
Vehicle Dynamics
```

### Drive Cycle

The simulation begins with a custom drive cycle derived from speed data recorded during operation of the project's electric vehicle.

The drive cycle provides the reference vehicle velocity to the virtual system.

```text
Recorded Vehicle Speed
          │
          ▼
     Drive Cycle
          │
          ▼
   Reference Velocity
          │
          ▼
 Longitudinal Driver
```

The reference velocity is used by the Longitudinal Driver to determine the required acceleration or deceleration behavior.

---

### Longitudinal Driver

The Longitudinal Driver compares the desired vehicle velocity with the simulated vehicle velocity.

The model uses:

* Reference velocity
* Feedback velocity
* Grade

and produces acceleration/deceleration commands.

```text
                 Reference Velocity
                         │
                         ▼
                ┌──────────────────┐
                │  Longitudinal    │
                │     Driver       │
                └──────────────────┘
                         ▲
                         │
                  Feedback Velocity

                         │
                         ▼
              Acceleration / Deceleration
                     Commands
```

The exact internal control algorithm is not specified in the available project documentation, so no specific controller type is assumed here.

---

### PWM / Control

The control stage converts the longitudinal driver commands into signals used by the motor/inverter system.

The Simulink model contains signals associated with:

* PWM
* Reference
* Reverse
* Brake

```text
Longitudinal Driver
        │
        ▼
 Control Commands
        │
        ▼
   PWM / Control
        │
   ┌────┼────┐
   │    │    │
   ▼    ▼    ▼
 REF   REV  BRK
        │
        ▼
 H-Bridge Inverter
```

The exact PWM switching frequency and internal switching algorithm are not specified in the available project material.

---

### Battery

The virtual vehicle uses an NMC lithium-ion battery model.

The battery provides electrical power to the inverter and motor.

```text
              Battery
                 │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
     Voltage            Current
        │                 │
        └────────┬────────┘
                 ▼
              Electrical
                Power
                 │
                 ▼
              Inverter
```

The battery model is also used for SOC and energy-consumption analysis.

---

### Inverter

The virtual powertrain contains a PWM-controlled H-Bridge inverter.

The inverter acts as the interface between the battery and the PMSM motor.

```text
Battery DC Power
       │
       ▼
┌──────────────────┐
│  H-Bridge         │
│  Inverter         │
└──────────────────┘
       │
       ▼
 Electrical Power
       │
       ▼
    PMSM Motor
```

---

### PMSM

The virtual powertrain uses a six-phase Permanent Magnet Synchronous Motor (PMSM).

The motor converts electrical input from the inverter into mechanical torque.

```text
Electrical Input
       │
       ▼
H-Bridge Inverter
       │
       ▼
 Six-Phase PMSM
       │
       ▼
Electromagnetic Torque
       │
       ▼
Mechanical Rotation
       │
       ▼
   Drivetrain
```

The PMSM forms the main electromechanical conversion stage of the virtual powertrain.

---

### Gearbox / Drivetrain

The motor's mechanical output is transferred to the wheels through the drivetrain.

The project documentation describes a gearbox-chain drive.

```text
PMSM
 │
 ▼
Motor Shaft
 │
 ▼
Gear Reduction
 │
 ▼
Drivetrain / Chain
 │
 ▼
Wheels
 │
 ▼
Vehicle Motion
```

The drivetrain transfers and transforms motor torque and rotational speed before the mechanical output reaches the wheels.

---

### Vehicle Dynamics

The vehicle dynamics model calculates the longitudinal motion of the vehicle based on the applied traction force and opposing forces.

The model considers:

* Traction force
* Aerodynamic drag
* Rolling resistance
* Gradient force
* Vehicle mass

The longitudinal force balance is represented as:

```text
m × a =
Ftraction
− Fdrag
− Froll
− Fgrade
```

where:

* `m` = vehicle mass
* `a` = vehicle acceleration
* `Ftraction` = traction force
* `Fdrag` = aerodynamic drag
* `Froll` = rolling resistance
* `Fgrade` = gradient force

#### Traction Force

```text
Ftraction = Twheel / rw
```

where:

* `Twheel` = wheel torque
* `rw` = effective wheel radius

#### Aerodynamic Drag

```text
Fdrag = 0.5 × ρ × Cd × A × v²
```

where:

* `ρ` = air density
* `Cd` = aerodynamic drag coefficient
* `A` = frontal area
* `v` = vehicle velocity

#### Rolling Resistance

```text
Froll = Crr × m × g
```

where:

* `Crr` = rolling resistance coefficient
* `m` = vehicle mass
* `g` = gravitational acceleration

#### Gradient Force

```text
Fgrade = m × g × sin(θ)
```

where:

* `θ` = road gradient angle

The resulting acceleration is integrated to obtain vehicle velocity.

```text
Net Force
    │
    ▼
Acceleration
    │
    ▼
Integration
    │
    ▼
Vehicle Velocity
```

The calculated vehicle velocity is fed back to the Longitudinal Driver.

---

## 7. Data Flow

The complete virtual simulation follows this flow:

```text
Custom Drive Cycle
        │
        ▼
Reference Vehicle Speed
        │
        ▼
Longitudinal Driver
        │
        ▼
Acceleration / Deceleration Command
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
        ├──────────────► Vehicle Speed
        │                      │
        │                      └──────► Feedback
        │
        ├──────────────► Distance
        │
        └──────────────► Energy / SOC
```

### Distance Calculation

Distance is calculated by integrating vehicle velocity:

```text
Distance = ∫ Velocity dt
```

```text
Vehicle Velocity
       │
       ▼
     1 / s
  Integrator
       │
       ▼
    Distance
```

### SOC Calculation

The battery SOC is estimated using Coulomb counting:

```text
SOC(t) = SOC(t₀) − ∫ I(t) / Q dt
```

where:

* `SOC(t)` = current state of charge
* `SOC(t₀)` = initial state of charge
* `I(t)` = battery current
* `Q` = battery capacity

---

## 8. Physical ↔ Virtual Integration

The physical vehicle provides measured data that can be compared against the virtual simulation.

```text
             PHYSICAL SYSTEM
                    │
                    ▼
                 Sensors
                    │
                    ▼
                  ESP32
                    │
                    ▼
             Serial Telemetry
                    │
                    ▼
             MATLAB / Analysis
                    │
                    ▼
               Validation
                    ▲
                    │
                    │
            MATLAB / Simulink
                    │
                    ▼
              Virtual EV
```

The available ESP32 firmware demonstrates serial telemetry acquisition for:

* RPM
* Voltage
* Current
* Ambient temperature
* Object temperature

This data can be used to evaluate the behavior of the virtual model against physical measurements.

The project documentation also discusses serial/UDP communication and bidirectional interfaces. However, the currently available ESP32 firmware specifically demonstrates serial telemetry, so UDP-based communication and bidirectional control are not assumed as implemented features here.

---

## 9. Validation

Validation is performed by comparing simulated vehicle behavior with physical measurements and recorded vehicle data.

Parameters considered for comparison include:

* Vehicle speed
* SOC
* Distance
* Torque
* Battery behavior

The project documentation reports deviations in the approximate range of `3–9%` for key parameters.

The remaining differences were associated with factors such as:

* Terrain effects
* Sensor noise
* Communication latency
* Unmodeled thermal effects
* Battery behavior not represented in the simplified model

```text
             Physical Measurements
                     │
                     ▼
               Measured Output
                     │
                     │
                     ▼
                 Comparison
                     ▲
                     │
                     │
               Simulated Output
                     │
                     ▲
                     │
              Virtual EV Model
```

Model calibration considers parameters such as:

* Vehicle mass
* Aerodynamic drag coefficient
* Rolling resistance
* Battery internal resistance

```text
Physical Vehicle Data
        │
        ▼
Measured Behaviour
        │
        ▼
Compare With Simulation
        │
        ▼
Parameter Calibration
        │
        ├── Vehicle Mass
        ├── Drag Coefficient
        ├── Rolling Resistance
        └── Battery Parameters
        │
        ▼
Updated Simulation
```

The validation results should be interpreted in the context of the experimental data available from the project.

---

## 10. Future Extensions

Potential future extensions identified during the project include:

* Regenerative braking
* Advanced thermal management
* Machine-learning-based prediction
* Cloud-based monitoring
* Hardware-in-the-loop (HIL) testing

These features are considered future extensions and are not represented as currently implemented components of the system.

---

## Summary

The Electric Vehicle Digital Twin combines physical measurements with a MATLAB/Simulink-based virtual vehicle model.

The overall workflow is:

```text
Physical Vehicle
       │
       ▼
Sensor Data
       │
       ▼
ESP32 Telemetry
       │
       ▼
MATLAB / Analysis
       │
       │
       ├─────────────────────┐
       │                     │
       ▼                     ▼
Physical Measurements    Virtual Simulation
                             │
                             ▼
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
                    Speed / Distance / SOC
                             │
                             ▼
                         Validation
```

The digital twin therefore provides a workflow for representing the electric vehicle virtually, analyzing its powertrain and dynamics, and comparing the simulation against real-world vehicle data.

```

**This is the version I would use.** It keeps your exact 10-point structure, while still covering the important technical details underneath the relevant sections.
```
