import
  strutils, sequtils, json, times, sugar

const
  rdFormat = "yyyy-M-d"
  wdFormat = "yyyy-MM-dd"

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
      "when": %now().format(wdFormat),
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
      "when": %now().format(wdFormat),
      "exp": %exp,
      "month": %month
    }
    if title != "":
      data["title"] = %title

    logData["exp"].add(data)

proc readLog*(logData: JsonNode): (seq[DateTime], seq[int]) =
  var logSeq: seq[tuple[date: DateTime, value: int]]
  for node in logData["log"]:
    var value = 0
    value.inc(try: node["bank"].getInt except: 0)
    value.inc(try: node["cash"].getInt except: 0)
    value.inc(try: node["auPay"].getInt except: 0)
    value.dec(try: node["card"].getInt except: 0)
    value.inc(try: node["adj"].getInt except: 0)
    logSeq.add((node["when"].getStr.parse(rdFormat), value))

  var expSeq: seq[tuple[date: DateTime, months: int, value: int]]
  for node in logData["exp"]:
    expSeq.add((node["when"].getStr.parse(rdFormat), node["month"].getInt, node["exp"].getInt))

  let
    lastLogData = logData["log"][logData["log"].len - 1]
    lastDate = lastLogData["when"].getStr.parse(rdFormat)

  for log in logSeq:
    if log.date.year < lastDate.year - 4 and
        not (log.date.year == lastDate.year - 5 and log.date.month.ord == 12):
      continue

    var expVal = log.value
    for exp in expSeq.filter(x => log.date < x.date + x.months.months and x.date < log.date):
      expVal.inc(exp.value * (exp.months - between(exp.date, log.date).months) div exp.months)

    result[0].add(log.date)
    result[1].add(expVal)
