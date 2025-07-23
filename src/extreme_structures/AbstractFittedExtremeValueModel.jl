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