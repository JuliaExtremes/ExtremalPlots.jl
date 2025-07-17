module ExtremePlots

using Distributions, Gadfly
import Plots

include("histplot.jl")
include("probplot.jl")
include("qqplot.jl")
include("returnlevelplot.jl")
include("utils.jl")

end
