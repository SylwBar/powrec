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

## Installation

1. Connect INA219 board.
2. Enable I2C bus using raspi-config tool.
3. Detect INA219 chip(s) using i2cdetect tool:
```
$ i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:                         -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: 40 41 42 43 -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --                   
```
4. Enable fast-mode (400kb/s) I2C bus speed. 
- edit /boot/config.txt file,
- find dtparam=i2c_arm=on,
- add i2c_arm_baudrate=400000 entry, complete line should look like this:
```
dtparam=i2c_arm=on,i2c_arm_baudrate=400000
```
Switching to fast-mode is optional but required for fast sampling rates (miliseconds).
Reading single current value using I2C read takes 800us using default mode and 200us using fast mode.

5. Install Erlang and Elixir: sudo apt install erlang elixir
6. Install Gnuplot on RaspberryPI. This step is optional, but it is comfortable to run Gnuplot on RasPI and watch results without copying data files. 
