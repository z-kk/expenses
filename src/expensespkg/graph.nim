import
  std / [sequtils, times, sugar],
  gnuplot

proc plotYear*(x: seq[DateTime], y: seq[int], fileName = "", commands: seq[string] = @[]) =
  cmd "set timefmt \"%m-%d\""
  cmd "set xdata time"
  cmd "set xtics format \"%m\""

  var
    yr: int
    xx: seq[DateTime]
    yy: seq[int]

  for i, d in x:
    if d.year != yr:
      if yr > 0:
        plot(xx.map(x => x.format("M-d")), yy, $yr)
      yr = d.year
      xx = @[]
      yy = @[]
    xx.add(d)
    yy.add(y[i])
  if yr > 0:
    plot(xx.map(x => x.format("M-d")), yy, $yr)

  withGnuplot:
    for command in commands:
      cmd(command)
    fileName.png
