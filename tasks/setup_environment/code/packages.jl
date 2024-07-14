##This script instantiates the Julia packages used throughout the project.

import Pkg
Pkg.activate("../output")
Pkg.instantiate()
using CSV, DataFrames, Plots, Random
open("../output/julia_packages.txt", "w") do f
    write(f, "Successfully instantiated Project.toml")
end
