# Exercice d'implémentation 3

Il s'agit d'une battle entre deux métaheuristiques à savoir:
    - L'heuristique **GRASP**
    - L'*Algorithme **Génétique** (AG)
pour résoudre des problèmes de *SPP* (Set Packing Problème)

## Function du projet

### La fonction *resoudreSPP(fname)*

Elle implémente successivement l'heuristique GRASP (**grasp_timed**) et AG (**genealgo_timed**) sur une instance qui lui est passé en paramètre.

#### La fonction *grasp_timed(A, C, duration=60, interval=10, alpha=0.6)*

- *A* : Matrice des contraintes
- *C* : Vecteur des coûts 
- *duration* : Durée de la recherche GRASP
- *interval* : Pas de mise à jour des valeurs minimale, moyenne et maximale trouvée au cours 
    de l'implémentation
- *alpha* : le paramètre aléatoire de l'algorithme GRASP (valeur prise entre 0 et 1)


#### La fonction *genealgo_timed(A, C, pop_size::Int=40, max_time::Float64=60.0, sample_step::Float64=10.0)*

- *A* : Matrice des contraintes
- *C* : Vecteur des coûts 
- *duration* : Durée de la recherche GRASP
- *interval* : Pas de mise à jour des valeurs minimale, moyenne et maximale trouvée au cours 
    de l'implémentation

### La fonction *experimentationSPP()*

Elle ne prend pas de paramètres. Elle appelle pour chaque instance du dossier *dat/*
la fonction *resoudreSPP()*

### La fonction *resoudreSPP(fname)*

- *fname* : Chemin vers l'instance SPP

# Implémentation du projet
## Packages à installer

    - *Statistics*
    - *Random*
    - *Combinatorics*
    - *Plots*

Positionner dans à racine du projet faire : 

```sh
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```
## Expérimentation

A la racine faire: 

```sh
julia> include("livrableEI3.jl")
julia> experimentationSPP()
```
