import expensespkg/[submodule, graph]

import
  strutils, json

const
  LogFileName = "exp.json"

proc main() =
  stdout.write("月次ログ入力[Y/n]: ")
  let isMonthLog = (stdin.readLine.toLowerAscii != "n")

  stdout.write("出費ログ入力[y/N]: ")
  let isExpLog = (stdin.readLine.toLowerAscii == "y")

  var logData =
    try:
      parseFile(LogFileName)
    except:
      %*{"log": [], "exp": []}
  logData.setLog(isMonthLog, isExpLog)
  LogFileName.writeFile(logData.pretty(4))

  let (x, y) = logData.readLog

  plotYear(x, y, "log.png")

when isMainModule:
  main()
