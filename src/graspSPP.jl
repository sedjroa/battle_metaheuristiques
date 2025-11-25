using Combinatorics  # pour combinaisons
include("kpexchange.jl")
include("greedySPP.jl")

function grasp_timed(A, C, duration=60, interval=10, alpha=0.6)
    """
    Exécute GRASP pendant 'duration' secondes,
    et affiche Zmin, Zmax, Zmoy toutes les 'interval' secondes.
    """
    the_zs = Dict(
    "z"    => [],
    "zmin" => [],
    "zmax" => [],
    "zmoy" => [],
    "t"    => []
    )
    start_time = time()
    next_check = start_time + interval

    while (time() - start_time) < duration
        # --- une exécution du GRASP  ---
        z = graspSPP(C, A, alpha)    
        push!(the_zs["z"], z)

        # --- vérification du temps ---
        if time() >= next_check
            
            zmin, zmax, zmoy = minimum(the_zs["z"]), maximum(the_zs["z"]), mean(the_zs["z"])
            push!(the_zs["zmin"] ,zmin)
            push!(the_zs["zmax"] ,zmax)
            push!(the_zs["zmoy"] ,zmoy)
            elapsed = round(time() - start_time, digits=1)
            push!(the_zs["t"] ,elapsed)
            next_check += interval
        end
    end
    return the_zs
end

function graspSPP(C, A, alpha=0.6)
    z_best, n = 0, 10
    for i in 1:n
        z = search_solution(C, A, alpha)
        if z > z_best
            z_best = z
        end
    end
    
    return z_best
end

function search_solution(C, A, alpha=0.6)
    x, z = greedySPP(C, A, alpha)
    k, p = 1, 1  # paramètres du k-p-exchange
    newx, newz = kpexchange(x, k, p,z, C, A)
    return newz
end
