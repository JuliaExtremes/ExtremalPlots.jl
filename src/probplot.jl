"""
    compute_pp_coordinates(pd::Distribution, y::AbstractVector{<:Real})

Compute the coordinates for a probability–probability plot comparing the empirical distribution of the sample `y` with the theoretical distribution `pd`.

## Details

Returns a tuple `(empirical_probs, theoretical_probs)`, where:
- `empirical_probs` are the empirical cumulative probabilities using the Gumbel plotting position.
- `theoretical_probs` are the corresponding cumulative probabilities of `pd`.
"""
function compute_pp_coordinates(pd::Distribution, y::AbstractVector{<:Real})
    q, empirical_probs = ecdf(y)
    theoretical_probs = cdf.(pd, q)
    return empirical_probs, theoretical_probs
end

"""
    compute_qq_coordinates(pd::Distribution, y::AbstractVector{<:Real})

Compute the coordinates for a quantile-quantile plot comparing the empirical distribution of the sample `y` with the theoretical distribution `pd`.

## Details

Returns a tuple `(empirical_quantiles, theoretical_quantiles)`, where:
- `empirical_quantiles` are the empirical qunatiles using the Gumbel plotting position.
- `theoretical_quantiles` are the corresponding quantiles of `pd`.
"""
function compute_qq_coordinates(pd::Distribution, y::AbstractVector{<:Real})
    empirical_quantiles, p = ecdf(y)
    theoretical_quantiles = quantile.(pd, p)
    return empirical_quantiles, theoretical_quantiles
end







"""
    probplot(pd::Distribution, y::AbstractVector{<:Real})

Generate a probability–probability plot comparing the empirical distribution of `y` against the theoretical distribution `pd`.

## Details

### Arguments
- `pd`: A univariate probability distribution from `Distributions.jl`.
- `y`: A sample vector of real-valued observations.

### Returns
A `Gadfly.Plot` object.

### Example
```julia
using Distributions, ExtremePlots

y = rand(Gumbel(), 100)
p = probplot(Gumbel(), y)
```
"""
function probplot(pd::Distribution, y::AbstractVector{<:Real}; title::String="")
    
    empirical_probs, theoretical_probs = compute_pp_coordinates(pd, y)
    
    l1 = layer(y = empirical_probs, x = theoretical_probs, Geom.point)
    l2 = layer(y = empirical_probs[[1, end]], x = empirical_probs[[1, end]], Geom.line, Theme(default_color="black", line_style=[:dash]))

    return Gadfly.plot(l2, l1,
        Guide.xlabel("Empirical probability"), Guide.ylabel("Estimated probability"), Guide.title(title),
        Theme(discrete_highlight_color=c->nothing, default_color="grey"))
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
using Distributions, ExtremePlots

y = rand(Gumbel(), 100)
p = qqplot(Gumbel(), y)
```
"""
function qqplot(pd::Distribution, y::AbstractVector{<:Real}; title::String="")
    
    empirical_quantiles, theoretical_quantiles = compute_qq_coordinates(pd, y)
    
    l1 = layer(y = empirical_quantiles, x = theoretical_quantiles, Geom.point)
    l2 = layer(y = empirical_quantiles[[1, end]], x = empirical_quantiles[[1, end]], Geom.line, Theme(default_color="black", line_style=[:dash]))

    return Gadfly.plot(l2, l1,
        Guide.xlabel("Empirical quantile"), Guide.ylabel("Estimated quantile"), Guide.title(title),
        Theme(discrete_highlight_color=c->nothing, default_color="grey"))
end

