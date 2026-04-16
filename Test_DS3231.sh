#!/bin/sh

# Verify data written to I2C device DS3231

#
# Author: Martin Eden
# Last mod.: 2026-04-16
#

#
# When writing to DS3231, first data byte is read/write pointer value.
# It's auto-incremented index for data reading and writing.
#

lua Write.lua 104 0
lua Read.lua 104 10

lua Write.lua 104 0 1 32 2 7 4 4 1 64 1 1

lua Write.lua 104 0
lua Read.lua 104 10

# 2026-04-16
