
# TODO move in Extremes.jl
function isstationary(fm::AbstractExtremeValueModel)
    return Extremes.getcovariatenumber(fm) == 0
end

"""
    diagnosticplots(fm::AbstractFittedExtremeValueModel)

Diagnostic plots
"""
function diagnosticplots(fm::AbstractFittedExtremeValueModel)

    f1 = probplot(fm)
    f2 = qqplot(fm)
    f3 = histplot(fm)

    if isstationary(fm.model)
        f4 = returnlevelplot(fm)
    else
        f4 = Gadfly.plot()
    end

    return gridstack([f1 f2; f3 f4])
end

function histplot(fm::AbstractFittedExtremeValueModel;
    title::String = "",
    xlabel::String = "Data",
    ylabel::String = "Model density")

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm)[]
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.histplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
    
end

function probplot(fm::AbstractFittedExtremeValueModel;
    title::String = "",
    xlabel::String = "Empirical probability",
    ylabel::String = "Model probability")

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm)[]
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.probplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
    
end

function qqplot(fm::AbstractFittedExtremeValueModel;
    title::String = "",
    xlabel::String = "Empirical quantile",
    ylabel::String = "Model quantile")

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm)[]
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.qqplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
    
end

function returnlevelplot(fm::AbstractFittedExtremeValueModel;
    title::String = "",
    xlabel::String = "Return period",
    ylabel::String = "Return level"
)

    if isstationary(fm.model)
        values = fm.model.data.value
        pd = Extremes.getdistribution(fm)[]
        return ExtremePlots.returnlevelplot(pd, values; title=title, xlabel=xlabel, ylabel=ylabel)
    else
        @warn "The graph is optimized for stationary models; the provided model is not stationary."
        return nothing
    end
end




"""
    qqplotci(fm::AbstractFittedExtremeValueModel, α::Real = 0.05;
             title::String = "",
             xlabel::String = "Model quantile",
             ylabel::String = "Empirical quantile")

Generates a Quantile-Quantile (QQ) plot with pointwise confidence or credible intervals
for a fitted extreme value model.

The plot compares the empirical quantiles to the model-predicted quantiles,
and adds pointwise confidence intervals of level `1 - α`.

# Arguments
- `fm`: A fitted extreme value model (`AbstractFittedExtremeValueModel`)
- `α`: Significance level for the interval (default: `0.05`)
- `title`: Plot title
- `xlabel`, `ylabel`: Axis labels

# Returns
- A `Gadfly.Plot` object

# Notes
- This function is currently only available for **stationary** models (i.e., with no covariates).

# See also
- [`returnlevelplotci`](@ref), [`qqplot`](@ref)

# Example
```julia
using Distributions, Extremes

pd = GeneralizedExtremeValue(0, 1, 0)
y = rand(pd, 300)
fm = gevfit(y)

qqplotci(fm)
"""
function qqplotci(fm::AbstractFittedExtremeValueModel, α::Real = 0.05;
title::String = "",
xlabel::String = "Model quantile",
ylabel::String = "Empirical quantile")

@assert 0 < α < 1 "The confidence level α must be in (0, 1)."
@assert isstationary(fm.model) "Confidence intervals are only available for stationary models."

pd = Extremes.getdistribution(fm)[]
empirical_quantiles, model_quantiles = compute_qq_coordinates(pd, fm.model.data.value)
_, p = ecdf(fm.model.data.value)

q_inf = Vector{Float64}(undef, length(p))
q_sup = Vector{Float64}(undef, length(p))

for (i, pᵢ) in enumerate(p)
    c = cint(returnlevel(fm, 1 / (1 - pᵢ)), 1 - α)[]
    q_inf[i] = c[1]
    q_sup[i] = c[2]
end

return Gadfly.plot(
    x = model_quantiles, y = empirical_quantiles, ymin = q_inf, ymax = q_sup,
    Geom.point, Geom.abline(style = :dash), Geom.ribbon,
    Theme(
        default_color = "black",
        lowlight_color = c -> "lightgray",
        discrete_highlight_color = c -> nothing
    ),
    Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title))
end

function returnlevelplotci(fm::AbstractFittedExtremeValueModel, α::Real=.05,
    title::String = "",
    xlabel::String = "Return period",
    ylabel::String = "Return level")

    @assert 0 < α < 1 "The confidence level α must be in (0, 1)."
    @assert isstationary(fm.model) "Confidence intervals are only available for stationary models."

    pd = Extremes.getdistribution(fm)[]
    empirical_quantile, empirical_return_period, model_quantile = compute_rl_coordinates(pd, fm.model.data.value)

    _, p = Extremes.ecdf(fm.model.data.value)

    q_inf = Vector{Float64}(undef, length(p))
    q_sup = Vector{Float64}(undef, length(p))

    for (i, pᵢ) in enumerate(p)
        c = cint(returnlevel(fm, 1 / (1 - pᵢ)), 1 - α)[]
        q_inf[i] = c[1]
        q_sup[i] = c[2]
    end

    l1 = layer(x = empirical_return_period, y = empirical_quantile, Geom.point, Theme(default_color="black", discrete_highlight_color=c->nothing))
    l2 = layer(x = empirical_return_period, y = model_quantile, Geom.line, Theme(default_color="black", line_style=[:dash]))
    l3 = layer(x = empirical_return_period, ymin=q_inf, ymax=q_sup, Geom.ribbon, Theme(lowlight_color=c->"lightgray"))
 

    return Gadfly.plot(l1,l2,l3, Scale.x_log10,
        Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title))

end