import
  std / [strformat, times],
  ggplotnim

const
  DateFormat = "yyyy-MM-dd"

proc plotYear*(fileName: string, x: seq[DateTime], y: seq[int]) =
  var
    year: seq[int]
    xx: seq[float]
    breaks: seq[float]

  for i, d in x:
    let
      yr = (d + initDuration(days=10)).year
      dur = d - parse($yr & "-01-01", DateFormat)
    year.add yr
    xx.add ("2001-01-01".parse(DateFormat) + dur).toTime.toUnixFloat

  for i in 1 .. 12:
    breaks.add "2001-{i:02}-01".fmt.parse(DateFormat).toTime.toUnixFloat

  let
    df = toDf({"month": xx, "exp": y, "year": year})
  proc monthFormat(x: float): string =
    x.fromUnixFloat.format("MMM")
  proc valueFormat(x: float): string =
    $int(x / 10000)

  df.ggplot(aes(x=factor("month"), y=factor("exp"), color=factor("year"))) +
    geom_line() + geom_point(aes(shape=factor("year"))) +
    #scale_x_date(breaks=breaks, isTimestamp=true, formatString="MMM", timeZone=local()) +
    scale_x_continuous(breaks=breaks, labels=monthFormat) +
    scale_y_continuous(labels=valueFormat) +
    fileName.ggsave
