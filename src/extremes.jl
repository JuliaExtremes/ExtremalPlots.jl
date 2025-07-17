

function isstationary(fm::AbstractExtremeValueModel)
    return Extremes.getcovariatenumber(fm) == 0
end

function histplot(fm::AbstractFittedExtremeValueModel;
    title::String = "",
    xlabel::String = "Data",
    ylabel::String = "Density")

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
    xlabel::String = "Empirical quantile",
    ylabel::String = "Estimated quantile")

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
    ylabel::String = "Estimated quantile")

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
