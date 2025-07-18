using Documenter
using ExtremePlots
using Distributions, Extremes, Gadfly

# Determine if we're running in a CI environment
CI = get(ENV, "CI", nothing) == "true"

makedocs(
    sitename = "ExtremePlots.jl",
    format = Documenter.HTML(
        prettyurls = CI,
        size_threshold_warn = 10^8,    # Optional: warning threshold for asset size
        size_threshold = 10^9,         # Optional: hard threshold for asset size
        example_size_threshold = 10^9  # Optional: threshold for example output size
    ),
    pages = [
        "index.md",
        "Tutorial" =>["Diagnostic plots" => "tutorial/plots.md",
                "Diagnostic plots for Extremes.jl" => "tutorial/extremes.md"
            ],
        "functions.md"
    ]
)

if CI
    deploydocs(
        repo = "github.com/JuliaExtremes/ExtremePlots.jl.git",
        devbranch = "main",  # Optional: set to "main" if "dev" doesn't exist
        versions = ["stable" => "v^", "v#.#", "main"],
        push_preview = false,
        target = "build"
    )
end

