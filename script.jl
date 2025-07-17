using Distributions

using Pkg
pkg"activate ."

using ExtremePlots

pd = Exponential(1.)

y = rand(pd, 1000)

p = ExtremePlots.probplot(pd, y)
p = ExtremePlots.probplot(pd, y; title="Probability plot")

p = ExtremePlots.qqplot(pd, y)
p = ExtremePlots.qqplot(pd, y; title="Quantile-Quantile plot")

p = ExtremePlots.returnlevelplot(pd, y)
p = ExtremePlots.returnlevelplot(pd, y; title="Return level plot")

p = ExtremePlots.histplot(pd, y)
p = ExtremePlots.histplot(pd, y; title="Histogram")

x = rand(pd, 1000)

p = ExtremePlots.qqplot(x, y)
p = ExtremePlots.qqplot(x, y, interpolation=false)