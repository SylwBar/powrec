# PowRec

**Power recording for Raspberry PI HATs based on INA219**

This tool records current data measured by Current/Power monitor HATs based on INA219 chip.

Example boards:

https://www.waveshare.com/wiki/Current/Power_Monitor_HAT

It is possible to log current data with 1ms sampling rate.

The tool is not able to display any data by itself, but it prepares necessary files that could be loaded by Gnuplot.

Example capture of some MCU power consumtion measured with 1ms sampling rate (units: second and mA):

![example](https://user-images.githubusercontent.com/8614048/215347579-e108aa01-b94b-4d97-b512-a06bd7e9af9d.png)

PowRec is designed to run on Raspberry PI.
Tested Raspberry PIs and OSes:

* Raspberry Pi 3 Model B Rev 1.2, Raspberry Pi OS with desktop, Debian version: 11 (bullseye), 32-bit.
