using Combinatorics  # pour combinaisons

"""
    k_p_exchange_neighbors(x::Vector{Int}, k::Int, p::Int, z, C, A)

Génère tous les vecteurs voisins de `x` selon un k-p-exchange :
- retire jusqu'à k éléments activés (1 -> 0)
- ajoute jusqu'à p éléments désactivés (0 -> 1)

Retourne un tableau de vecteurs voisins.
"""
function kpexchange(x, k, p,z, C, A)
    
    z_best, x_best = z, x

    neighbors = find_neighbors(x, k, p)

#=     println("\nNombre de voisins générés: ", length(neighbors))
 =#
    for neighbor in neighbors
        if(all(sum(A[:, neighbor .== 1], dims=2) .< 2))
            neighbor_cost = sum(C[neighbor .== 1])
            if(neighbor_cost>z_best)
                x_best, z_best = neighbor, neighbor_cost
            end 
        end
    end
    return x_best, z_best
end

function find_neighbors(x, k, p)
    n = length(x)
    neighbors = []

    # indices actifs et inactifs
    active_indices = findall(x .== 1)
    #println("Indices actifs: ", active_indices)
    inactive_indices = findall(x .== 0)
    #println("Indices inactifs: ", inactive_indices)

    # pour chaque nombre de retraits de 1 à k
    for num_remove in 1:min(k,length(active_indices))
        for remove_comb in combinations(active_indices, num_remove)
            #print(remove_comb, " -> ")
            # créer une solution intermédiaire après retrait
            x_removed = copy(x)
            for i in remove_comb
                x_removed[i] = 0
            end

            # pour chaque nombre d'ajouts de 1 à p
            for num_add in 1:min(p,length(inactive_indices))
                for add_comb in combinations(inactive_indices, num_add)
                    x_neighbor = copy(x_removed)
                    for j in add_comb
                        x_neighbor[j] = 1
                    end
                    push!(neighbors, x_neighbor)
                end
            end
        end
    end
    return neighbors
end