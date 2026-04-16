## What

(2026-04)

Client for [I2C text console][me_I2C_Console] written in Lua for Linux.

Here is pure Lua 5.5 implementation and command-line scripts to
scan I2C bus, read from device and write to device.


## Notes

### Don't reconnect to device in program

Each of these scripts opens device, runs one command and closes device.
Device opening takes like 3.5 seconds.

If you want to write on-line program to I2C device -- don't use
these command-line scripts. Open device as teletype stream and use
module functions.

### I2C protocol

I2C is transactions protocol with byte granularity.
Each transaction is either Read or Write.

Communication protocols of real I2C devices are extensions of this.

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

[me_I2C_Console]:
