using Statistics
using Random
function genealgo_timed(A, C, pop_size::Int=40, 
                                   max_time::Float64=60.0, 
                                   sample_step::Float64=10.0)

    start = time()
    next_sample = sample_step
    nvars = size(A, 2)

    # Initialisation population
    Random.seed!(1)
    population = [rand(0:1, nvars) for _ in 1:pop_size]
    fitnesses = [fitness(C, x) for x in population]
    # println(map(x -> needOfReparation(A,x), population))

    # Pour stocker l’évolution
    results = Dict(
        "z" => [],
    "zmin" => [],
    "zmax" => [],
    "zmoy" => [],
    "t"    => []
    )

    # Boucle principale 
    gen = 0
    while (time() - start) < max_time 
        gen += 1
        # println("Nombre d'individus faisables G($gen): ", length(findall(ind -> all(A * ind .<= 1), population)))
        # 1Sélection des deux meilleurs
        #println("G($gen):  $(sum(map(x -> needOfReparation(A,x), population))) non faisable people in population")
        
        parent_idxs = partialsortperm(fitnesses, 1:2, rev=true)
        parents = [population[i] for i in parent_idxs]

        #println("Parents:  $(sum(map(x -> needOfReparation(A,x), parents))) non faisable parents")

        # Croisement
        childs = crossing_over(parents)
        #println("crossing_over:  $(sum(map(x -> needOfReparation(A,x), childs))) non faisable childs")

        # Réparation
        childs = [xReparation(A, c) for c in childs]
       # println("Crossing O Repair:  $(sum(map(x -> needOfReparation(A,x), childs))) non faisable childs")

        # Mutation
        childs = [mutation(c) for c in childs]
        #println("Mutation:  $(sum(map(x -> needOfReparation(A,x), childs))) non faisable childs")

        # Réparation post mutation
        childs = [xReparation(A, c) for c in childs]
        #println("Mutation Repair:  $(sum(map(x -> needOfReparation(A,x), childs))) non faisable childs")

        # Évaluation
        children_fitnesses = [fitness(C, c) for c in childs]
        push!(results["z"], children_fitnesses[1])
        push!(results["z"], children_fitnesses[2])
        
        # Remplacement élitiste
        generation, fitnesses = elitist_replacement!(A, population, fitnesses,childs, children_fitnesses)
        population = generation
        # Enregistrement toutes les sample_step secondes
        elapsed = time() - start
        # println(elapsed)
        if elapsed >= next_sample 
            z_min = minimum(results["z"])
            z_max = maximum(results["z"])
            z_avg = mean(results["z"])

            push!(results["zmin"] ,z_min)
            push!(results["zmax"] ,z_max)
            push!(results["zmoy"] ,z_avg)
            
            push!(results["t"] ,elapsed)

            next_sample += sample_step
        end

    end
    return results
end

function needOfReparation(A, x)
    return any( (A * x ).> 1)
end

# ===== fitness =====
function fitness(C, x)
    return sum(C[x .== 1])
end

# ===== réparation =====
function xReparation(A, x; max_iter::Int=1000)
    x = copy(x)
    iter = 0
    ax = A * x

    while any(ax .> 1) && iter < max_iter
        # contraintes violées
        bad_constraints = findall(ax .> 1)


        for c in bad_constraints
            
            cols = findall(i -> A[c, i] == 1 && x[i] == 1, 1:size(A, 2))
            if !isempty(cols)
                bad_col = rand(cols)
                x[bad_col] = 0
            end
        end

        
        ax = A * x
        iter += 1
    end

    if any(ax .> 1)
       
        ones_pos = findall(==(1), x)
        shuffle!(ones_pos)
        for idx in ones_pos
            x[idx] = 0
            if !any((A * x) .> 1)
                break
            end
        end
    end

    return x
end

# ===== crossing_over  =====
function crossing_over(parents::Vector{Vector{Int}}, cop=0.8)
    
    if length(parents) < 2
        return copy(parents)
    end

    p1 = copy(parents[1])
    p2 = copy(parents[2])
    n = length(p1)
    childs = Vector{Vector{Int}}()

    if rand() < cop
        
        point = rand(1:n-1)
        child1 = vcat(p1[1:point], p2[(point+1):end])
        child2 = vcat(p2[1:point], p1[(point+1):end])
    else
       
        child1 = copy(p1)
        child2 = copy(p2)
    end

    push!(childs, child1)
    push!(childs, child2)
    return childs
end

# ===== mutation  =====
function mutation(child::Vector{Int}, mup=0.1)
    if rand() < mup
        ind = rand(1:length(child))
        child[ind] = 1 - child[ind]
    end
    return child
end

# ===== remplacement élitiste  =====
function elitist_replacement!(A,population, fitness, children, children_fit)
    # Ranger les enfants par fitness décroissant (et réordonner children_fit également)
    order = sortperm(children_fit, rev=true)
    children = children[order]
    children_fit = children_fit[order]

    # Trier population par fitness décroissante (du meilleur au pire)
    sorted_indices = sortperm(fitness, rev=true)

    cpt = 0
    for (child, fit_child) in zip(children, children_fit)
        worst_idx = sorted_indices[end]  # index du pire
        if fit_child > fitness[worst_idx]
            population[worst_idx] = child
            fitness[worst_idx] = fit_child
            cpt += 1 
            sorted_indices = sortperm(fitness, rev=true) # réactualiser l'ordre
        end
    end

    if cpt == 0
        non_faisable_people_idx = findall(x -> needOfReparation(A,x) == true, population)

        if length(non_faisable_people_idx) > 1
            order = rand(non_faisable_people_idx, 2)
            population[order[1]] = children[1]
            fitness[order[1]] = fitness[1]
            population[order[2]] = children[2]
            fitness[order[2]] = fitness[2]
        else
            order = rand(1:length(population), 2)
            population[order[1]] = children[1]
            fitness[order[1]] = fitness[1]
            population[order[2]] = children[2]
            fitness[order[2]] = fitness[2]
        end
    end     
    return population, fitness
end
