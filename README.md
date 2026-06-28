# TM4C123GX-GPIO-LED
A short program written in ARM assembly (Cortex M4) for a EK-TM4C123GX Launch Pad. This configures the GPIO to turn on an external LED.

PB5 on the lefthand side of the header pins is set to open drain. Connect the LED circuit between the 3.3V supply above the PB5 pin and PB5. By default PB5 is set to 0 for gnd. Set to 1 for open circuit.
