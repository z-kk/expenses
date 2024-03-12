import
  std / [strutils],
  docopt,
  expensespkg / [submodule, nimbleInfo]

proc readCmdOpt() =
  ## Read command line options.
  let doc = """
    $1

    Usage:
      $1 [--local]

    Options:
      -h --help         Show this screen.
      --version         Show version.
      --local           Use local dir.
  """ % [PlotApp]
  let args = doc.dedent.docopt(version = Version)

  useLocalDir = args["--local"].to_bool

when isMainModule:
  readCmdOpt()
  getLog().plotGraph
