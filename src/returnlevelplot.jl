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
function returnlevelplot(pd::Distribution, y::AbstractVector{<:Real};
    title::String = "",
    xlabel::String = "Return Period",
    ylabel::String = "Return Level")

    empirical_quantile, empirical_return_period, theoretical_quantile = compute_rl_coordinates(pd, y)
    
    l1 = layer(x = empirical_return_period, y = empirical_quantile, Geom.point)
    l2 = layer(x = empirical_return_period, y = theoretical_quantile, Geom.line, Theme(default_color="black", line_style=[:dash]))

    return plot(l2, l1, Scale.x_log10, Guide.xlabel("Return Period"), Guide.ylabel("Return Level"),
        Guide.title(title), Theme(discrete_highlight_color=c->nothing, default_color="grey")) 
end
