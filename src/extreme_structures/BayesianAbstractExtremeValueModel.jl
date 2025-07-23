function histplot(fm::BayesianAbstractExtremeValueModel;
    title::String = "",
    xlabel::String = "Empirical probability",
    ylabel::String = "Model probability")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm, θ̂)
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

     return ExtremePlots.histplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
end

function probplot(fm::BayesianAbstractExtremeValueModel;
    title::String = "",
    xlabel::String = "Empirical probability",
    ylabel::String = "Model probability")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm, θ̂)
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.probplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
    
end

function qqplot(fm::BayesianAbstractExtremeValueModel;
    title::String = "",
    xlabel::String = "Empirical quantile",
    ylabel::String = "Model quantile")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        m = fm.model.data.value
        pd = Extremes.getdistribution(fm, θ̂)
    else
        m = Extremes.standardize(fm)
        pd = Extremes.standarddist(fm.model)
    end

    return ExtremePlots.qqplot(pd, m; title=title, xlabel=xlabel, ylabel=ylabel)
    
end

function returnlevelplot(fm::BayesianAbstractExtremeValueModel;
    title::String = "",
    xlabel::String = "Return period",
    ylabel::String = "Return level")

    θ̂ = Extremes.findposteriormode(fm)

    if isstationary(fm.model)
        values = fm.model.data.value
        pd = Extremes.getdistribution(fm, θ̂)
        return ExtremePlots.returnlevelplot(pd, values; title=title, xlabel=xlabel, ylabel=ylabel)
    else
        @warn "The graph is optimized for stationary models; the provided model is not stationary."
        return nothing
    end
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