import
  std / [strutils, rdstdin],
  docopt,
  expensespkg / [webserver, submodule, nimbleInfo]

type
  CmdOpt = object
    port: int
    appName: string
    isCli: bool

const
  DefaultPort = 5000

proc readCmdOpt(): CmdOpt =
  ## Read command line options.
  let doc = """
    $1

    Usage:
      $1 [<appName>] [-p <port>] [--local]
      $1 --cli

    Options:
      -h --help         Show this screen.
      --version         Show version.
      --cli             Execute cli.
      --local           Use ./public dir.
      -p --port <port>  Http server port [default: $2]
      <appName>         jester appName
  """ % [AppName, $DefaultPort]
  let args = doc.dedent.docopt(version = Version)

  result.port = try: parseInt($args["--port"]) except: DefaultPort
  if args["<appName>"]:
    result.appName = "/" & $args["<appName>"]
  result.isCli = args["--cli"].to_bool
  useLocalDir = args["--local"].to_bool

proc cli() =
  let
    isMonthLog = ("月次ログ入力[Y/n]: ".readLineFromStdin.toLowerAscii != "n")
    isExpLog = ("出費ログ入力[y/N]: ".readLineFromStdin.toLowerAscii == "y")

  var logData = getLog()
  logData.setLog(isMonthLog, isExpLog)
  logData.saveLog

  logData.plotGraph

when isMainModule:
  let cmdOpt = readCmdOpt()
  if cmdOpt.isCli:
    cli()
  else:
    getLog().plotGraph
    startWebServer(cmdOpt.port, cmdOpt.appName)
