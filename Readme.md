[![DeepWiki][DeepWiki_Logo]][DeepWiki_Repo]

## What

(2026-04)

Client for [I²C text console][me_I2C_Console] written in Lua for Linux.

Underlying text protocol is compatible with [Itness][Itness] format,
designed to be easy for parsing/compiling and still be readable/writable
for human from another side of communication channel.

Here is command-line Lua scripts to call Scan/Read/Write commands for I²C bus.
And client side code in Lua 5.5.

Code is self-sufficient, no additional Lua modules are required.

## Code

* [Command-line example][Example_Cli]
* [Lua example][Example_Lua]
* [Implementation][Implementation]


## Requirements

* Hardware
  * Arduino Uno with `me_I2C_Console` firmware
  * I²C devices connected to Arduino
  * USB connection to Arduino

* Software
  * Linux
  * `bash`, `stty`, `sleep`
  * Lua 5.5

## Install/remove

Clone repo / delete directory


## Notes

### Don't reconnect to device in program

Each of these scripts opens device, runs one command and closes device.
Device opening takes like 3.5 seconds.

If you want to write on-line program to I²C device -- don't use
these command-line scripts. Open device as teletype stream and use
module functions.

### I²C protocol

I²C is transactions protocol with byte granularity.
Each transaction is either Read or Write.

Communication protocols of real I²C devices are extensions of this.

Different devices use different custom extensions. You'll need datasheet.

For example to read sixth byte from real-time clock DS3231
(device id `104`) you do

  ```
  I2C_Write 104 5 -- set read pointer to offset 5
  I2C_Read 104 1 -- read one byte
  ```

Similarly to set sixth byte to 10 you do

  ```
  I2C_Write 104 5 10
  ```

or

  ```
  I2C_Write 104 5
  I2C_Write 104 10
  ```

### Portability

UART communication from host is done via device file.
For Linux it's name is like `/dev/ttyUSB0`, for DOS like `COM1`..

I'm not going to port it to other desktop OS's. If you wish to do
it yourself be advised that opening communication port is more tricky
than just opening file.

### Throttling

If you can send data fast it does not mean device can handle them fast.

Sending 1000 bytes and then pausing for 1000 ms is not the same as
sending 1000 bytes with pause 1 ms after each byte. Small chunks are
preferred.

Implementation does small delay when sending data items.

## See also

* [`me_I2C_Console`][me_I2C_Console] -- my I²C server firmware for ATmega328
* [`Itness`][Itness] -- strings tree serialization format (mine too lol)
* [`DS3231 GUI`][Ds3231_Gui] -- my old frontend project for I²C device
* [`workshop`][workshop] -- my personal Lua framework
* [My other projects][Contents]

[DeepWiki_Logo]: https://deepwiki.com/badge.svg
[DeepWiki_Repo]: https://deepwiki.com/martin-eden/Lua-I2C_Console

[Example_Cli]: Test_DS3231.sh
[Example_Lua]: Read.lua
[Implementation]: I2C_Client/

[me_I2C_Console]: https://github.com/martin-eden/Embedded-me_I2C_Console
[Itness]: https://github.com/martin-eden/Lua-Itness
[Ds3231_Gui]: https://github.com/martin-eden/tekui_ds3231
[workshop]: https://github.com/martin-eden/workshop
[Contents]: https://github.com/martin-eden/contents
