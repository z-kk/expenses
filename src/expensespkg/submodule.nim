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

    bank.stdinInt("銀行預金")
    cash.stdinInt("財布現金")
    cardval.stdinInt("カード料")
    auPay.stdinInt("auPay残高")

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

    stdout.write("タイトル: ")
    let title = stdin.readLine
    exp.stdinInt("金額")
    stdout.write("有効期間[月]: ")
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
