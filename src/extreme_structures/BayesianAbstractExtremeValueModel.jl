function histplot(fm::BayesianAbstractExtremeValueModel;
    title::String="",
    xlabel::String="Empirical probability",
    ylabel::String="Model probability")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm.model, θ̂)[]
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.histplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
end

function probplot(fm::BayesianAbstractExtremeValueModel;
    title::String="",
    xlabel::String="Empirical probability",
    ylabel::String="Model probability")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm.model, θ̂)[]
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.probplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)

end

function qqplot(fm::BayesianAbstractExtremeValueModel;
    title::String="",
    xlabel::String="Empirical quantile",
    ylabel::String="Model quantile")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm.model, θ̂)[]
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.qqplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)

end

function returnlevelplot(fm::BayesianAbstractExtremeValueModel;
    title::String="",
    xlabel::String="Return period",
    ylabel::String="Return level")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        values = fm.model.data.value
        pd = Extremes.getdistribution(fm.model, θ̂)[]
        return ExtremePlots.returnlevelplot(pd, values; title=title, xlabel=xlabel, ylabel=ylabel)
    else
        @warn "The graph is optimized for stationary models; the provided model is not stationary."
        return nothing
    end
end



function qqplotci(fm::BayesianAbstractExtremeValueModel, α::Real=0.05;
    title::String="",
    xlabel::String="Model quantile",
    ylabel::String="Empirical quantile")

    @assert 0 < α < 1 "The confidence level α must be in (0, 1)."
    @assert isstationary(fm.model) "Confidence intervals are only available for stationary models."

    θ̂ = Extremes.findposteriormode(fm)
    pd = Extremes.getdistribution(fm.model, θ̂)[]
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
        x=model_quantiles, y=empirical_quantiles, ymin=q_inf, ymax=q_sup,
        Geom.point, Geom.abline(style=:dash), Geom.ribbon,
        Theme(
            default_color="black",
            lowlight_color=c -> "lightgray",
            discrete_highlight_color=c -> nothing
        ),
        Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title))
end


function returnlevelplotci(fm::BayesianAbstractExtremeValueModel, α::Real=0.05,
    title::String="",
    xlabel::String="Return period",
    ylabel::String="Return level")

    @assert 0 < α < 1 "The confidence level α must be in (0, 1)."
    @assert isstationary(fm.model) "Confidence intervals are only available for stationary models."

    θ̂ = Extremes.findposteriormode(fm)
    pd = Extremes.getdistribution(fm.model, θ̂)[]
    empirical_quantile, empirical_return_period, model_quantile = compute_rl_coordinates(pd, fm.model.data.value)

    _, p = Extremes.ecdf(fm.model.data.value)

    q_inf = Vector{Float64}(undef, length(p))
    q_sup = Vector{Float64}(undef, length(p))

    for (i, pᵢ) in enumerate(p)
        c = cint(returnlevel(fm, 1 / (1 - pᵢ)), 1 - α)[]
        q_inf[i] = c[1]
        q_sup[i] = c[2]
    end

    l1 = layer(x=empirical_return_period, y=empirical_quantile, Geom.point, Theme(default_color="black", discrete_highlight_color=c -> nothing))
    l2 = layer(x=empirical_return_period, y=model_quantile, Geom.line, Theme(default_color="black", line_style=[:dash]))
    l3 = layer(x=empirical_return_period, ymin=q_inf, ymax=q_sup, Geom.ribbon, Theme(lowlight_color=c -> "lightgray"))


    return Gadfly.plot(l1, l2, l3, Scale.x_log10,
        Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title))

end





## Proper Bayesian diagnostic plots


# function probplot_data(fm::BayesianAbstractExtremeValueModel)::DataFrame

#     checkstationarity(fm.model)

#     y, p̂ = ecdf(fm.model.data.value)

#     dist = getdistribution(fm)

#     p_sim = Array{Float64}(undef, length(dist), length(y))

#     i = 1

#     for d in eachslice(dist, dims=1)
#         p_sim[i,:] = cdf.(d, y)
#         i +=1
#     end

#     p = vec(mean(p_sim, dims=1))

#     return DataFrame(Model = p, Empirical = p̂)

# end

# function qqplot_data(fm::BayesianAbstractExtremeValueModel)::DataFrame

#     checkstationarity(fm.model)

#     y, p = ecdf(fm.model.data.value)

#     dist = getdistribution(fm)

#     q_sim = Array{Float64}(undef, length(dist), length(y))

#     i = 1

#     for d in eachslice(dist, dims=1)
#         q_sim[i,:] = quantile.(d, p)
#         i +=1
#     end

#     q = vec(mean(q_sim, dims=1))

#     return DataFrame(Model = q, Empirical = y)

# end

# function returnlevelplot_data(fm::BayesianAbstractExtremeValueModel)::DataFrame

#     checkstationarity(fm.model)

#     y, p = ecdf(fm.model.data.value)

#     T = 1 ./ (1 .- p)

#     dist = getdistribution(fm)

#     q_sim = Array{Float64}(undef, length(dist), length(y))

#     i = 1
#     for d in eachslice(dist, dims=1)
#         q_sim[i,:] = quantile.(d, p)
#         i +=1
#     end

#     q = vec(mean(q_sim, dims=1))

#     return DataFrame(Data = y, Period = T, Level = q)

# end

# function histplot_data(fm::BayesianAbstractExtremeValueModel)::Dict

#     checkstationarity(fm.model)

#     x = fm.model.data.value
#     n = length(x)
#     nbin = Int64(ceil(sqrt(n)))

#     dist = getdistribution(fm)

#     xmin = quantile(dist[1], 1/1000)
#     xmax = quantile(dist[1], 1 - 1/1000)
#     xp = range(xmin, xmax, length=1000)

#     h_sim = Array{Float64}(undef, length(dist), length(xp))

#     i = 1
#     for d in eachslice(dist, dims=1)
#         h_sim[i,:] = pdf.(d, xp)
#         i +=1
#     end

#     h = vec(mean(h_sim, dims=1))

#     return Dict(:h => DataFrame(Data = x), :d => DataFrame(DataRange = xp, Density = h),
#         :nbin => nbin, :xmin => xmin, :xmax => xmax)

# end