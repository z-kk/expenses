# Package

version       = "0.2.1"
author        = "z-kk"
description   = "household expenses"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["expenses"]
binDir        = "bin"



# Dependencies

requires "nim >= 2.0.0"
requires "jester"
requires "docopt"
requires "ggplotnim"



# Tasks

import std / [os, strutils]
task r, "build and run":
  exec "nimble build"
  withDir binDir:
    let staticDir = "public"
    if not staticDir.dirExists:
      exec "ln -s $1 $2" % [".." / srcDir / "html", staticDir]
  exec "nimble ex"

task ex, "run without build":
  withDir binDir:
    exec "." / bin[0]


# Before / After

before build:
  let infoFile = srcDir / bin[0] & "pkg" / "nimbleInfo.nim"
  infoFile.parentDir.mkDir
  infoFile.writeFile("""
    const
      AppName* = "$#"
      Version* = "$#"
  """.dedent % [bin[0], version])

after build:
  let infoFile = srcDir / bin[0] & "pkg" / "nimbleInfo.nim"
  infoFile.writeFile("""
    const
      AppName* = ""
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
