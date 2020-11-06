# Package

version       = "0.1.0"
author        = "z-kk"
description   = "household expenses"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["expenses"]
binDir        = "bin"



# Dependencies

requires "nim >= 1.2.4"
requires "gnuplot"
