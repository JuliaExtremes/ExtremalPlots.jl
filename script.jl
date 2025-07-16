using Distributions

using Pkg
pkg"activate ."

using ExtremePlots

pd = Exponential(1.)

y = rand(pd, 100)

p = ExtremePlots.probplot(pd, y)
p = ExtremePlots.probplot(pd, y; title="Probability plot")

p = ExtremePlots.qqplot(pd, y)
p = ExtremePlots.qqplot(pd, y; title="Quantile-Quantile plot")

p = ExtremePlots.returnlevelplot(pd, y)
p = ExtremePlots.returnlevelplot(pd, y; title="Return level plot")