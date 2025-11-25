function greedySPP(C, A, alpha=1.0)
    m, n = size(A)
    x = falses(n)
    chosen_rows = falses(m)
    utility = C ./ vec(sum(A, dims=1))

    run =true
    while run
       #=  println("u = ", utility, " | ulim = ", ulim) =#

        ulim = minimum(utility) + alpha * (maximum(utility) - minimum(utility))
        rcl = findall(utility .>= ulim) 
    
        if isempty(rcl)
            run = false
            break
        end
        selected_indice = rand(rcl)
        utility[selected_indice] = -1
        conflict = A[:, selected_indice] .& chosen_rows
        if all( conflict .== false )
            x[selected_indice] = true
            chosen_rows = (chosen_rows .== true) .| (A[:, selected_indice] .== 1)
        end
        if all(chosen_rows .== true) || all(utility .== -1)
            run = false
            break
        end
        
    end
    z = sum(C[x .== true])
    return x, z
end
