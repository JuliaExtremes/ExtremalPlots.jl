"""
    compute_qq_coordinates(pd::Distribution, y::AbstractVector{<:Real})

Compute the coordinates for a quantile-quantile plot comparing the empirical distribution of the sample `y` with the theoretical distribution `pd`.

## Details

Returns a tuple `(empirical_quantiles, model_quantiles)`, where:
- `empirical_quantiles` are the empirical quantiles using the Gumbel plotting position.
- `model_quantiles` are the corresponding quantiles of `pd`.
"""
function compute_qq_coordinates(pd::Distribution, y::AbstractVector{<:Real})
    empirical_quantiles, p = ecdf(y)
    model_quantiles = quantile.(pd, p)
    return empirical_quantiles, model_quantiles
end

"""
    compute_qq_coordinates(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}; interpolation::Bool=true)

Compute quantile-quantile plot coordinates comparing two datasets.

## Details

This function returns matched quantiles for `x` and `y`, which can be used to create QQ plots.
When `interpolation=true`, it uses the empirical cumulative distribution function (ECDF) of `y`
to generate probability levels `p`, then computes `quantile(x, p)`. When `interpolation=false`,
it samples the shorter length from both datasets without replacement, sorts them, and returns the sorted vectors.

### Arguments
- `x`: Reference data vector from which theoretical quantiles will be computed.
- `y`: Observed data vector to be compared against `x`.
- `interpolation`: If `true` (default), perform ECDF-based quantile matching. If `false`, match by sorted sampling.

### Returns
A pair `(x_quantile, y_quantile)` of vectors that can be plotted against each other in a QQ plot.
"""
function compute_qq_coordinates(x::AbstractVector{<:Real}, y::AbstractVector{<:Real}; interpolation::Bool=true)
    if interpolation
        # Quantile matching by computing the ECDF of y and evaluating quantiles from x
        y_sorted, p = ecdf(y)
        x_quantile = quantile(x, p)
        y_quantile = y_sorted
    else
        n = min(length(x), length(y))
        x_quantile = sort(sample(x, n, replace=false))
        y_quantile = sort(sample(y, n, replace=false))
    end

    return x_quantile, y_quantile
end

"""
    qqplot(pd::Distribution, y::AbstractVector{<:Real})

Generate a quantile-quantile plot comparing the empirical qunatile of `y` against the theoretical quantiles of `pd`.

## Details

### Arguments
- `pd`: A univariate probability distribution from `Distributions.jl`.
- `y`: A sample vector of real-valued observations.

### Returns
A `Gadfly.Plot` object.

### Example
```julia
using Distributions, ExtremalPlots

y = rand(Gumbel(), 100)
p = qqplot(Gumbel(), y)
```
"""
function qqplot(pd::Distribution, y::AbstractVector{<:Real};
    title::String = "",
    xlabel::String = "Empirical quantile",
    ylabel::String = "Model quantile")
    
    empirical_quantiles, model_quantiles = compute_qq_coordinates(pd, y)

    return Gadfly.plot(x=empirical_quantiles, y=model_quantiles, Geom.point, 
            Geom.abline(color = "black", style = :dash),
            Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title),
            Theme(discrete_highlight_color=c->nothing, default_color="grey"))
end

"""
    qqplot(x::AbstractVector{<:Real}, y::AbstractVector{<:Real};
           interpolation::Bool=true, title::String="",
           xlabel::String="Empirical quantiles", ylabel::String="Empirical quantiles")

Create a quantile-quantile plot comparing two empirical distributions.

## Details

### Arguments
- `x`: Reference data vector, used to compute theoretical or sample quantiles.
- `y`: Observed data vector to be compared.
- `interpolation`: If `true` (default), quantiles are matched via interpolation based on ECDF.
  If `false`, the shortest length is sampled from both vectors without replacement and sorted.
- `title`: Title of the plot.
- `xlabel`: Label for the x-axis (default: `"Empirical quantiles"`).
- `ylabel`: Label for the y-axis (default: `"Empirical quantiles"`).

### Returns
A Gadfly plot object.
"""
function qqplot(x::AbstractVector{<:Real}, y::AbstractVector{<:Real};
    interpolation::Bool = true,
    title::String = "",
    xlabel::String = "Empirical quantiles",
    ylabel::String = "Empirical quantiles")

    x_quantiles, y_quantiles = compute_qq_coordinates(x, y; interpolation = interpolation)

    return Gadfly.plot(x=x_quantiles, y=y_quantiles, Geom.point, 
            Geom.abline(color = "black", style = :dash),
            Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title),
            Theme(discrete_highlight_color=c->nothing, default_color="grey"))
end

