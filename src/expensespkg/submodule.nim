import
  strutils, json, times

proc stdinInt(value: var int, title: string) =
  while true:
    stdout.write(title & ": ")
    try:
      value = stdin.readLine.parseInt
      break
    except Exception as e:
      echo e.msg
      continue

proc setLog*(logData: var JsonNode, isMonthLog, isExpLog: bool) =
  if isMonthLog:
    var
      bank, cash, cardval, auPay: int

    bank.stdinInt("$B6d9TMB6b(B")
    cash.stdinInt("$B:bI[8=6b(B")
    cardval.stdinInt("$B%+!<%INA(B")
    auPay.stdinInt("auPay$B;D9b(B")

    let data = %*{
      "when": %now().format("yyyy-MM-dd"),
      "bank": %bank,
      "cash": %cash,
      "card": %*cardval,
      "auPay": %auPay,
    }

    logData["log"].add(data)

  if isExpLog:
    var
      exp, month: int

    stdout.write("$B%?%$%H%k(B: ")
    let title = stdin.readLine
    exp.stdinInt("$B6b3[(B")
    stdout.write("$BM-8z4|4V(B[$B7n(B]: ")
    try:
      month = stdin.readLine.parseInt
    except:
      month = 0

    var data = %*{
      "when": %now().format("yyyy-MM-dd"),
      "exp": %exp,
      "month": %month
    }
    if title != "":
      data["title"] = %title

    logData["exp"].add(data)
