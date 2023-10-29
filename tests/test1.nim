import
  unittest,
  std / [os, strutils, times, json]

import expensespkg/submodule {.all.}

suite "calc log":
  setCurrentDir("tests")
  logFilePath().removeFile

  var
    log: JsonNode
    x: seq[DateTime]
    y: seq[int]

  test "get empty log":
    log = getLog()
    check log == %*{"log": [], "exp": []}

  # make log data
  for y in 1 .. 6:
    for m in 1 .. 12:
      log["log"].add %*{
        "when": "200$#-$#-01" % [$y, ("0" & $m)[^2..^1]],
        "bank": 500000,
        "cash": 0,
        "auPay": 0,
        "card": 0,
      }

  test "readLog - all same":
    (x, y) = log.readLog
    check x[0].format(wdFormat) == "2002-01-01"
    for i in y:
      check i == 0

  # change log data
  log["log"][^11]["cash"] = %10000
  log["log"][^10]["auPay"] = %10000
  log["log"][^8]["card"] = %10000

  test "readLog - log fluct":
    (x, y) = log.readLog
    check y[^12] == 0
    check y[^11] == 10000
    check y[^10] == 0
    check y[^9] == -10000
    check y[^8] == -10000
    check y[^7] == 10000
    check y[^6] == 0

  # add exp data
  for m in 1 .. 2:
    log["exp"].add %*{
      "when": "2005-0$#-10" % [$m],
      "exp": 6000,
      "month": 6,
    }

  test "readLog - add exp":
    (x, y) = log.readLog
    check y[^24] == 0
    check y[^23] == 6000 - 1000
    check y[^22] == -1000 + 6000 - 1000
    check y[^21] == -1000 - 1000
    check y[^20] == -1000 - 1000
    check y[^19] == -1000 - 1000
    check y[^18] == -1000
    check y[^17] == 0

  # add temp exp data
  log["exp"].add %*{
    "when": "2005-08-10",
    "exp": 5000,
    "month": 0,
  }

  test "readLog - add temp exp":
    (x, y) = log.readLog
    check y[^17] == 0
    check y[^16] == 5000
    check y[^15] == 0

  # set adj log
  log["log"][^14]["adj"] = %1000

  test "readLog - adjust":
    (x, y) = log.readLog
    check y[^14] == 1000
    check y[^13] == -1000

  test "save log":
    log.saveLog
    let t = getLog()
    check log.pretty == t.pretty

  logFilePath().removeFile
