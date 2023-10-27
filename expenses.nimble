# Package

version       = "0.1.1"
author        = "z-kk"
description   = "household expenses"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["expenses", "plotExpLog"]
binDir        = "bin"



# Dependencies

requires "nim >= 2.0.0"
requires "jester"
requires "docopt"
requires "gnuplot >= 2.7.1"



# Tasks

import std / [os, strutils]
task r, "build and run":
  exec "nimble build"
  withDir binDir:
    let staticDir = "public"
    exec "if [ ! -s $1 ]; then ln -s $2 $1; fi" % [staticDir, ".." / "src" / "html"]
    exec "." / bin[0]


# Before / After

before build:
  let infoFile = srcDir / bin[0] & "pkg" / "nimbleInfo.nim"
  infoFile.parentDir.mkDir
  infoFile.writeFile("""
    const
      AppName* = "$#"
      PlotApp* = "$#"
      Version* = "$#"
  """.dedent % [bin[0], bin[1], version])

after build:
  let infoFile = srcDir / bin[0] & "pkg" / "nimbleInfo.nim"
  infoFile.writeFile("""
    const
      AppName* = ""
      PlotApp* = ""
      Version* = ""
  """.dedent)

before install:
  let
    dataDir = getDataDir() / bin[0]
    staticDir = getConfigDir() / bin[0] / "public"
  dataDir.mkDir
  if not staticDir.dirExists:
    staticDir.parentDir.mkDir
    cpDir("src" / "html", staticDir)
