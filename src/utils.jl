"""
    ecdf(y::AbstractVector{<:Real})

Compute the empirical cumulative distribution function using the Gumbel plotting positions.
"""
function ecdf(y::AbstractVector{<:Real})
    ys = sort(y)
    n = length(ys)
    p = collect(1:n) ./ (n + 1)  # Gumbel plotting positions
    return ys, p
end

# TODO move in Extremes.jl
function isstationary(fm::AbstractExtremeValueModel)
    return Extremes.getcovariatenumber(fm) == 0
end