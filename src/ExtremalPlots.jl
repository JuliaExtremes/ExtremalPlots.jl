module ExtremalPlots

using Distributions, Extremes, Gadfly

include("plots/histplot.jl")
include("plots/mrlplot.jl")
include("plots/probplot.jl")
include("plots/qqplot.jl")
include("plots/returnlevelplot.jl")
include("extremes_structures.jl")
include("utils.jl")

export
    probplot,
    qqplot,
    qqplotci,
    returnlevelplot,
    returnlevelplotci,
    histplot,
    diagnosticplots,
    mrlplot

end
