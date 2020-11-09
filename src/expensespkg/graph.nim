import
  gnuplot,
  sequtils, strformat, times, sugar

proc plt[X, Y](x: seq[X], y: seq[Y], fileName: string, title: string = "") =
  cmd "set terminal png"
  cmd &"set output \"{fileName}\""
  plot x, y, title

proc plotGraph*(x, y: seq[float], fileName: string, title: string = "") =
  plt(x, y, fileName, title)

proc plotGraph*(x, y: seq[int], fileName: string, title: string = "") =
  plotGraph(x.map(x => x.toFloat), y.map(x => x.toFloat), fileName, title)

proc plotGraph*(x: seq[DateTime], y: seq[float], fileName: string, title: string = "") =
  cmd "set timefmt \"%Y-%m-%d\""
  cmd "set xdata time"

  plt(x.map(x => x.format("yyyy-MM-dd")), y, fileName, title)

proc plotGraph*(x: seq[DateTime], y: seq[int], fileName: string, title: string = "") =
  plotGraph(x, y.map(x => x.toFloat), fileName, title)

proc plotYear*(x: seq[DateTime], y: seq[int], fileName: string) =
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
        plt(xx.map(x => x.format("M-d")), yy, fileName, $yr)
      yr = d.year
      xx = @[]
      yy = @[]
    xx.add(d)
    yy.add(y[i])
  if yr > 0:
    plt(xx.map(x => x.format("M-d")), yy, fileName, $yr)

proc graphCmd*(command: string) =
  cmd command
