import
  std / [os, strutils, json, rdstdin],
  expensespkg / [submodule, graph]

const
  LogFileName = "exp.json"

proc main() =
    isMonthLog = ("月次ログ入力[Y/n]: ".readLineFromStdin.toLowerAscii != "n")
    isExpLog = ("出費ログ入力[y/N]: ".readLineFromStdin.toLowerAscii == "y")

  var logData =
    try:
      parseFile(LogFileName)
    except:
      %*{"log": [], "exp": []}
  logData.setLog(isMonthLog, isExpLog)
  LogFileName.writeFile(logData.pretty(4))

  let (x, y) = logData.readLog

  setStyle(Linespoints)
  graphCmd("set grid")
  plotYear(x, y, "log.png")

when isMainModule:
  main()
