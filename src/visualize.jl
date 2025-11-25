function heuristicPlots(fname, zs)
    
    graphicname = fname
    zmin = zs["zmin"]
    zmax = zs["zmax"]
    zmoy = zs["zmoy"]
    t = zs["t"]

    plot(
    t, zmin,
    label = "Zmin",
    linewidth = 2,
    color = :blue,
    marker = :circle
)

    plot!(
        t, zmax,
        label = "Zmax",
        linewidth = 2,
        color = :red,
        marker = :utriangle
    )

    plot!(
        t, zmoy,
        label = "Zmoy",
        linewidth = 2,
        color = :green,
        marker = :diamond
    )

    xlabel!("Temps (s)")
    ylabel!("Valeurs de Z")
    title!("Évolution des performances")
    savefig("res/$graphicname.png")

end