# ExtremePlots

[![Build Status](https://github.com/JuliaExtremes/ExtremePlots.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaExtremes/ExtremePlots.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![documentation stable](https://img.shields.io/badge/docs-latest-blue.svg)](https://JuliaExtremes.github.io/ExtremePlots.jl/dev/)

**ExtremePlots.jl** is a Julia package that offers plotting tools specifically designed for extreme value analysis, with [`Gadfly.jl`](https://github.com/GiovineItalia/Gadfly.jl/tree/master) as the plotting backend.

## Features
- Histogram plot  
- Mean residual life plot  
- Probability–Probability (PP) plot  
- Quantile–Quantile (QQ) plot  
- Return level plot  

The empirical quantiles are computed using Gumbel plotting positions, as recommended by [Makkonen (2006)](https://journals.ametsoc.org/jamc/article/45/2/334/12668/Plotting-Positions-in-Extreme-Value-Analysis).

## Link with Extremes.jl

This package is also compatible with the data structures from [`Extremes.jl`](https://github.com/jojal5/Extremes.jl), a package for extreme value analysis in Julia.

Note that the Bayesian diagnostic plots provided in the current version of this package use the posterior mode as the Bayesian point estimate to construct the plots. Proper Bayesian plots may be included in a future version of the package. Sketches of the corresponding functions are included as comments in the relevant source files.

## Release Notes
- v0.1.1: Added diagnostic plots for Bayesian extreme value models.

### Reference
Makkonen, L. (2006). Plotting positions in extreme value analysis. *Journal of Applied Meteorology and Climatology*, 45(2), 334–340.
