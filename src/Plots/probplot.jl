"""
    probplot(pd::Distribution, y::AbstractVector{<:Real})

Probability plot
"""
function probplot(pd::Distribution, y::AbstractVector{<:Real})
    
    q, p = ecdf(y)
    p̂ = cdf.(pd, q)
    
    Plots.plot(p, p̂, seriestype = :scatter, markerstrokewidth=0, markercolor=:grey, label="",
        xlabel="Empirical probability", ylabel="Estimated probability")
    Plots.plot!(p[[1, end]], p[[1, end]], label="", ls=:dash, color=:black)
end