# Diagnostic plots

This page illustrates diagnostic plots provided by the `ExtremePlots.jl` package. These plots help assess the fit of extreme value models and explore the distribution of extreme data.

## Setup

```@setup plots
using Random
Random.seed!(12345)  # For reproducible examples
```

Load the required packages:
```@example plots
using Distributions, ExtremePlots, Gadfly
```

Simulate data from a Generalized Extreme Value (GEV) distribution:
```@example plots
pd = GeneralizedExtremeValue(0,1,0)
y = rand(pd, 300);
nothing #hide
```

## Histogram Plot

Displays a histogram of the data with the distribution overlay.

```@example plots
histplot(pd, y)
```

## Probability-Probability (PP) plot

Compares empirical and model probabilities.

```@example plots
probplot(pd, y)
```

## Quantile-Quantile (QQ) plot

Compares empirical and model quantiles.
```@example plots
qqplot(pd, y)
```

## Return level plot

Displays empirical and model-predicted return levels as a function of the return period.
```@example plots
returnlevelplot(pd, y)
```

## Mean residual life plot

Used to assess the suitability of a threshold for Peaks-Over-Threshold (POT) modeling.

```@example plots
mrlplot(y)
```