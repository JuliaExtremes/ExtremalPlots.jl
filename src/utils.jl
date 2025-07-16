"""
    ecdf(y::AbstractVector{<:Real})

Compute the empirical cumulative distribution function using the Gumbel plotting positions.

## Details

The empirical quantiles are computed using the Gumbel plotting positions, as recommended by [Makkonen (2006)](https://journals.ametsoc.org/jamc/article/45/2/334/12668/Plotting-Positions-in-Extreme-Value-Analysis).

### Example
```julia-repl
julia> (x, F̂) = Extremes.ecdf(y)
```

### Reference
Makkonen, L. (2006). Plotting positions in extreme value analysis. Journal of Applied Meteorology and Climatology, 45(2), 334-340.
"""
function ecdf(y::AbstractVector{<:Real})
    ys = sort(y)
    n = length(ys)
    p = collect(1:n) ./ (n + 1)  # Gumbel plotting positions
    return ys, p
end