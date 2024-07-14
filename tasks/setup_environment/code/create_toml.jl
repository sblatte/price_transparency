#This script can be run to create the Project.toml and Manifest.toml files. It should rarely be run. Typically, you just Pkg.activate().
#Ask before committing the results of running this script.

import Pkg
rm("../output/Project.toml",force=true)
rm("../output/Manifest.toml",force=true)
Pkg.activate("../output")
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("Plots")
Pkg.add("Random")

