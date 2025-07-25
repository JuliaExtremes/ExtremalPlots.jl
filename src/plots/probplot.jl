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
function probplot(pd::Distribution, y::AbstractVector{<:Real};
    title::String = "",
    xlabel::String = "Empirical probability",
    ylabel::String = "Model probability")
    
    empirical_probs, model_probs = compute_pp_coordinates(pd, y)

    return Gadfly.plot(x=empirical_probs, y=model_probs, Geom.point, 
            Geom.abline(color = "black", style = :dash),
            Guide.xlabel(xlabel), Guide.ylabel(ylabel), Guide.title(title),
            Theme(discrete_highlight_color=c->nothing, default_color="grey"))
end







