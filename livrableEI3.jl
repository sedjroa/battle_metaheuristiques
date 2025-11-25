# ============================================================
# livrableEI3.jl
# Auteurs : Amos GANDONOU
# Objectif : Bataille Métaheuristiques
#            pour le Set Packing Problem (SPP)
# ============================================================
include("src/loadSPP.jl")
include("src/genalgo.jl")
include("src/graspSPP.jl")
include("src/visualize.jl")
using Plots

# Se placer dans ce dossier automatiquement
const PROJECT_DIR = @__DIR__
cd(PROJECT_DIR)
#= println("Dossier de travail : ", PROJECT_DIR) =#

# Ajouter le sous-dossier src/ au chemin de chargement
#push!(LOAD_PATH, joinpath(PROJECT_DIR, "/"))

function resoudreSPP(fname)
    println("\nInstance: $fname")

    C, A = loadSPP(fname)

    
    z_gena = genealgo_timed(A,C,100,60.0,10.0)
    println("Génétic Algo ==> Z = $(maximum(z_gena["zmax"]))")
    
    z_grasp = grasp_timed(A,C,60, 10, 0.6)
    println("GRASP Algo ==> Z = $(maximum(z_grasp["zmax"]))")

    graphname =  split(fname, ['/', '\\'])[end]
    heuristicPlots(graphname, z_gena)
    heuristicPlots(splitext(graphname)[1], z_grasp)

end

function  experimentationSPP()
    println("\nLoading...")
    target = "./dat"
    fnames = readdir(target)

    for fname in fnames
        resoudreSPP(joinpath(target, fname))
    end
end