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
    compute_rl_coordinates(pd::Distribution, y::AbstractVector{<:Real}) 

Compute the coordinates for a return level (RL) plot, comparing the empirical and theoretical quantiles associated with estimated return periods.

## Details

### Arguments
- `pd`: A univariate probability distribution from `Distributions.jl`.
- `y`: A vector of real-valued observations.

### Returns
A tuple `(empirical_quantile, empirical_return_period, theoretical_quantile)`, where:
- `empirical_quantile`: Sorted values of the sample `y`.
- `empirical_return_period`: Return periods estimated from empirical probabilities using 
  the Gumbel plotting position, i.e., `1 / (1 - F̂)`.
- `theoretical_quantile`: Quantiles of the distribution `pd` at the same empirical probabilities.

### Example
```julia
using Distributions
y = rand(Gumbel(), 100)
q, T, q̂ = compute_rl_coordinates(Gumbel(), y)
```

### Notes

The return periods are estimated assuming a non-exceedance probability F̂ = i / (n + 1) as recommended
by Makkonen (2006).

#### Reference

Makkonen, L. (2006). "Plotting Positions in Extreme Value Analysis." Journal of Applied Meteorology
and Climatology, 45(2), 334–340.
"""
function compute_rl_coordinates(pd::Distribution, y::AbstractVector{<:Real})
    q, p = ecdf(y)
    
    empirical_quantile = q
    empirical_return_period = 1 ./ (1 .- p)
    theoretical_quantile = quantile.(pd, p)

    return empirical_quantile, empirical_return_period, theoretical_quantile
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


"""
    returnlevelplot(pd::Distribution, y::AbstractVector{<:Real}; title::String="") 

Generate a return level plot comparing empirical return levels with theoretical return levels from a fitted probability distribution.

## Details

### Arguments
- `pd`: A univariate distribution from `Distributions.jl`, representing the theoretical model.
- `y`: A vector of real-valued observations (e.g., annual maxima).
- `title`: *(Optional)* Title for the plot.

### Returns
A `Gadfly.Plot` object showing:
- **Points**: Empirical return levels computed using the Gumbel plotting position.
- **Dashed Line**: Theoretical return levels computed from the quantile function of `pd`.

### Example
```julia
using Gadfly, Distributions
y = rand(Gumbel(0, 1), 100)
returnlevelplot(Gumbel(0, 1), y, title="Return level plot")
```
"""
function returnlevelplot(pd::Distribution, y::AbstractVector{<:Real}; title::String="")

    empirical_quantile, empirical_return_period, theoretical_quantile = compute_rl_coordinates(pd, y)
    
    l1 = layer(x = empirical_return_period, y = empirical_quantile, Geom.point)
    l2 = layer(x = empirical_return_period, y = theoretical_quantile, Geom.line, Theme(default_color="black", line_style=[:dash]))

    return plot(l2, l1, Scale.x_log10, Guide.xlabel("Return Period"), Guide.ylabel("Return Level"),
        Guide.title(title), Theme(discrete_highlight_color=c->nothing, default_color="grey")) 
end



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
