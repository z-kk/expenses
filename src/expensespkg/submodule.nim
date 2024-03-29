import
  std / [os, strutils, sequtils, json, times, rdstdin, sugar],
  graph

when defined(release):
  import
    nimbleInfo

const
  LogFileName = "exp.json"
  LogImgName* = "log.png"
  rdFormat = "yyyy-M-d"
  wdFormat = "yyyy-MM-dd"

var
  useLocalDir*: bool

proc logFilePath(): string =
  when defined(release):
    if useLocalDir:
      LogFileName
    else:
      getDataDir() / AppName / LogFileName
  else:
    LogFileName

proc getLog*(): JsonNode =
  result =
    try:
      logFilePath().parseFile
    except:
      %*{"log": [], "exp": []}

proc saveLog*(data: JsonNode) =
  let path = logFilePath()
  path.parentDir.createDir
  path.writeFile(data.pretty(4))

proc readInt(title: string): int =
  while true:
    try:
      result = readLineFromStdin(title & ": ").parseInt
      break
    except Exception as e:
      echo e.msg
      continue

proc setLog*(logData: var JsonNode, isMonthLog, isExpLog: bool) =
  if isMonthLog:
    let
      bank = "銀行預金".readInt
      cash = "財布現金".readInt
      cardval = "カード料".readInt
      auPay = "auPay残高".readInt
      data = %*{
        "when": %now().format(wdFormat),
        "bank": %bank,
        "cash": %cash,
        "card": %cardval,
        "auPay": %auPay,
      }

    logData["log"].add(data)

  if isExpLog:
    let
      title = "タイトル: ".readLineFromStdin
      exp = "金額".readInt
      month =
        try:
          "有効期間[月]: ".readLineFromStdin.parseInt
        except:
          0

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
  if logSeq.len < 2:
    return

  var expSeq: seq[tuple[date: DateTime, title: string, months: int, value: int]]
  for node in logData["exp"]:
    if "title" in node:
      expSeq.add((node["when"].getStr.parse(rdFormat), node["title"].getStr, node["month"].getInt, node["exp"].getInt))
    else:
      expSeq.add((node["when"].getStr.parse(rdFormat), "", node["month"].getInt, node["exp"].getInt))

  for idx, log in logSeq:
    if idx == 0 or log.date.year < logSeq[^1].date.year - 4:
      continue

    result[0].add(log.date)
    result[1].add(log.value - logSeq[idx - 1].value)

  for idx, dt in result[0]:
    for exp in expSeq.filter(x => dt - months(x.months - 1) < x.date and x.date < dt):
      if dt < exp.date + 1.months:
        result[1][idx] += exp.value * (exp.months - 1) div exp.months
      else:
        result[1][idx] -= exp.value div exp.months
      if idx == result[0].high:
        echo exp.title, ": ", exp.value div exp.months, " 残: ", exp.months - between(exp.date, dt).months - 1
    for exp in expSeq.filter(x => dt - 1.months < x.date and x.date < dt and x.months == 0):
      result[1][idx] += exp.value

proc logGraphPath*(): string =
  when defined(release):
    if useLocalDir:
      LogImgName
    else:
      getDataDir() / AppName / LogImgName
  else:
    LogImgName

proc plotGraph*(log: JsonNode) =
  let (x, y) = log.readLog
  plotYear(x, y, logGraphPath(), @["set grid"])
