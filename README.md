# ExtremalPlots

[![Build Status](https://github.com/JuliaExtremes/ExtremalPlots.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaExtremes/ExtremalPlots.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![documentation stable](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaExtremes.github.io/ExtremalPlots.jl/dev/)

**ExtremalPlots.jl** is a Julia package that offers plotting tools specifically designed for extreme value analysis, with [`Gadfly.jl`](https://github.com/GiovineItalia/Gadfly.jl/tree/master) as the plotting backend.

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
