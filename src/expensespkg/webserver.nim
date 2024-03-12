import
  std / [os, osproc, strutils, json],
  jester,
  submodule, nimbleInfo

include "tmpl/index.tmpl"

proc getLogData(): JsonNode =
  ## ログデータ取得
  result = getLog()
  result["log"] = result["log"][^10..^1]
  result["exp"] = result["exp"][^10..^1]

proc updateLogData(req: Request): JsonNode =
  ## ログデータ更新
  result = %*{"err": "unknown error"}
  let data = req.formData

  if data["when"].body == "":
    result["err"] = %"日付が未入力"
    return
  if data["bank"].body == "":
    result["err"] = %"銀行預金が未入力"
    return
  if data["cash"].body == "":
    result["err"] = %"現金額が未入力"
    return
  if data["prepaid"].body == "":
    result["err"] = %"プリペイド額が未入力"
    return
  if data["card"].body == "":
    result["err"] = %"カード料が未入力"
    return

  var json = %*{}
  try:
    json["when"] = %data["when"].body
    json["bank"] = %data["bank"].body.parseInt
    json["cash"] = %data["cash"].body.parseInt
    json["auPay"] = %data["prepaid"].body.parseInt
    json["card"] = %data["card"].body.parseInt
    if data["adj"].body != "":
      json["adj"] = %data["adj"].body.parseInt

    var log = getLog()
    log["log"].add json
    log.saveLog

    result["err"] = %""
  except:
    result["err"] = %getCurrentExceptionMsg()

proc updateExpData(req: Request): JsonNode =
  ## 出費データ更新
  result = %*{"err": "unknown error"}
  let data = req.formData

  if data["when"].body == "":
    result["err"] = %"日付が未入力"
    return
  if data["exp"].body == "":
    result["err"] = %"金額が未入力"
    return
  if data["month"].body == "":
    result["err"] = %"有効月数が未入力"
    return

  var json = %*{}
  try:
    json["when"] = %data["when"].body
    json["exp"] = %data["exp"].body.parseInt
    json["month"] = %data["month"].body.parseInt
    if data["title"].body != "":
      json["title"] = %data["title"].body

    var log = getLog()
    log["exp"].add json
    log.saveLog

    result["err"] = %""
  except:
    result["err"] = %getCurrentExceptionMsg()

router rt:
  get "/":
    when defined(release):
      if useLocalDir:
        discard execProcess("." / PlotApp & " --local")
      else:
        discard execProcess(getHomeDir() / ".nimble/bin" / PlotApp)
    else:
      echo execProcess("." / PlotApp & " --local")
    resp indexPage(request.appName)
  get "/logdata":
    resp getLogData()
  get "/img/graph":
    resp logGraphPath().readFile
  post "/update/log":
    resp request.updateLogData
  post "/update/exp":
    resp request.updateExpData

proc startWebServer*(port: int, appName: string) =
  var staticDir = "public"
  when defined(release):
    if useLocalDir:
      staticDir = getCurrentDir() / staticDir
    else:
      staticDir = getConfigDir() / AppName / staticDir
  else:
    staticDir = getCurrentDir() / staticDir
  let settings = newSettings(port.Port, staticDir, appName)
  var jest = initJester(rt, settings)
  jest.serve
