# ExtremePlots

[![Build Status](https://github.com/JuliaExtremes/ExtremePlots.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaExtremes/ExtremePlots.jl/actions/workflows/CI.yml?query=branch%3Amain)

**ExtremePlots.jl** provides plotting tools tailored for extreme value analysis in Julia.

## Features
- Histogram plot  
- Mean residual life plot  
- Probability–probability (PP) plot  
- Quantile–quantile (QQ) plot  
- Return level plot  

The empirical quantiles are computed using Gumbel plotting positions, as recommended by [Makkonen (2006)](https://journals.ametsoc.org/jamc/article/45/2/334/12668/Plotting-Positions-in-Extreme-Value-Analysis).

This package is also compatible with the data structures from [`Extremes.jl`](https://github.com/jojal5/Extremes.jl), a package for extreme value analysis in Julia.

### Reference
Makkonen, L. (2006). Plotting positions in extreme value analysis. *Journal of Applied Meteorology and Climatology*, 45(2), 334–340.
