# Package

version       = "0.1.1"
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



# Tasks

import std / os
task r, "build and run":
  exec "nimble build"
  withDir binDir:
    exec "." / bin[0]
