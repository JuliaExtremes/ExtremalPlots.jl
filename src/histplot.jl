function histplot(pd::Distribution, y::AbstractVector{<:Real}; title::String="")

    nbin = ceil(Int64, sqrt(length(y)))

    a = repeat([0.55, 0.85], outer=nbin)

    xmin = quantile(pd, 1/500)
    xmax = quantile(pd, 1 - 1/500)

    l1 = layer(x = y, Geom.histogram(bincount=nbin, density=true), alpha=[a;a])
    l2 = layer(x -> pdf(pd, x), xmin, xmax, Theme(default_color=colorant"black"))

    return plot(l2, l1, Guide.xlabel("Data"), Guide.ylabel("Density"), Guide.title(title),
        Theme(default_color="grey"))

end