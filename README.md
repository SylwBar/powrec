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

## Compilation
The mix tool is used to manage elixir projects. Mix is delivered with elixir package.
1. Clone and enter into repository folder.
2. Download and compile dependencies:
```
$ mix deps.get
$ mix deps.compile
```
3. Compile powrec app:
```
$ mix compile
```

## Starting powrec

PowRec is executed using mix run command:
```
$ mix run powrec.exs opt1 opt2 ...
```
Options list could be displayed using -h option:
```
$ mix run powrec.exs -h
PowRec 0.0.1
powrec args:
--help,     -h: print help
--int-ms,   -m: sampling interval in ms
--log_name, -l: log name (without suffix)
```

## Options
### Sampling interval: --int-ms, -m:
Controls how often powrec will read data from INA219 chips. Minimum value is 1 ms. 
Default value is set to 100ms i.e. 10 current readings per second.

### Log name: --log_name, -l:
Name of recorded data file. Default value is "log". Powrec will produce following files based on this parameter:
- log.dat  : recorded data, plain ASCII format, comma separated values,
- log.plot : customized file for Gnuplot showing data plot.

## Runtime options
After executing, powrec records data in the backgroud providing also simple command line console:
```
PowRec 0.0.1
Enter h - for help
powrec> h
powrec commands:
d: toggle display
i: print info
h: help
q: quit program

powrec> 
```
Recording stops after selecting "q" option.

## Data analysis
Data plot will pop-up after executing gnuplot with produced log.plot file:
```
$ gnuplot log.plot
```

## Data sampling parameters
INA219 chip provides several options for measurements accuracy, range etc.
Those options will be slowly added in subsequent releases of powrec.
