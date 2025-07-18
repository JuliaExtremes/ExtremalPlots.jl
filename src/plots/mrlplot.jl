"""
    mrlplot_data(y::Vector{<:Real}, steps::Int = 100)::DataFrame

Compute the mean residual life from vector `y`.

The set of thresholds ranges from `minimum(y)` to the second-to-last larger
value in `steps` number of steps.
"""
function mrlplot_data(y::AbstractVector{<:Real}, steps::Int = 100)
    @assert steps > 0 "The number of steps must be positive."
    @assert length(y) >= 3 "At least 3 observations are required."

    sorted_y = sort(y)
    umin = sorted_y[1]
    umax = sorted_y[end-2]  # Avoid top 2 highest values to ensure excesses exist

    threshold = range(umin, stop = umax, length = steps)

    mrl = Vector{Float64}(undef, steps)
    lbound = Vector{Float64}(undef, steps)
    ubound = Vector{Float64}(undef, steps)

    for i in eachindex(threshold)
        excess = filter(z -> z > threshold[i], y) .- threshold[i]
        n = length(excess)

        if n > 1
            m = mean(excess)
            s = std(excess)
            mrl[i] = m
            lbound[i] = m - 1.96 * s / sqrt(n)
            ubound[i] = m + 1.96 * s / sqrt(n)
        else
            mrl[i] = NaN
            lbound[i] = NaN
            ubound[i] = NaN
        end
    end

return threshold, mrl, lbound, ubound

end


"""
    mrlplot(y::Vector{<:Real}, steps::Int = 100)

Mean residual plot
"""
function mrlplot(y::AbstractVector{<:Real}, steps::Int=100)

    threshold, mrl, lbound, ubound = mrlplot_data(y, steps)

    p = Gadfly.plot(x = threshold, y = mrl, ymin = lbound, ymax = ubound,
        Geom.line, Geom.ribbon, Guide.xlabel("Threshold"), Guide.ylabel("Mean Residual Life"),
        Theme(default_color="grey"))

    return p
end