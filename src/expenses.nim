import expensespkg/submodule

import
  strutils, json

const
  LogFileName = "exp.json"

proc main() =
  stdout.write("$B7n<!%m%0F~NO(B[Y/n]: ")
  let isMonthLog = (stdin.readLine.toLowerAscii != "n")

  stdout.write("$B=PHq%m%0F~NO(B[y/N]: ")
  let isExpLog = (stdin.readLine.toLowerAscii == "y")

  var logData =
    try:
      parseFile(LogFileName)
    except:
      %*{"log": [], "exp": []}
  logData.setLog(isMonthLog, isExpLog)
  LogFileName.writeFile(logData.pretty(4))

when isMainModule:
  main()
