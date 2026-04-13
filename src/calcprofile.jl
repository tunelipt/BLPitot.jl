# Calculando as características do perfil

export calclogprofile!, calcpowerprofile!, calcprofilefp!
using GLMakie

function calclogprofile!(fig, z, u; zref=nothing, hrough=nothing, kappa=0.4, zunit="mm", vunit="m/s")

    @assert length(z) == length(u)  "Tamanhos de `z` e `u` devem ser os mesmos!"
    
    npts = length(z)
    


    # Interval slider:
    isl = IntervalSlider(fig[1,2], range = 1:npts, startvalues=(1,npts),
                         horizontal=false)
    cc = fill(:blue, npts)
    color = lift(isl.interval) do ii
        idx = ii[1]:ii[2]
        cc .= :blue
        cc[idx] .= :red
        cc
    end
    fit = lift(isl.interval) do ii
        idx = ii[1]:ii[2]
        logprofile(z[idx], u[idx], kappa)
    end
    
    z0lab = lift(fit) do f
        z0 = round(f.z0, sigdigits=2)
        us = round(f.us, sigdigits=3)
         "Lei da parede z₀ = $(z0) ($zunit), u* = $us $(vunit)"
    end
    ucalc = lift(fit) do f
        f.(z)
    end
    
    ax = Axis(fig[1,1], xlabel="Velocidade ($vunit)", ylabel="Altura ($zunit)", yscale=log10,
              title=z0lab)
    fmeas = scatter!(ax, u, z, color=color, label="Perfil medido")
    ffit = lines!(ax, ucalc, z, color=:red, linewidth=2, label="Ajuste do perfil")
    
    
    if !isnothing(zref)
        hlines!(ax, zref, linestyle=:dash, color=:black, label="Altura de referência")
        
    end
    if !isnothing(hrough)
        hlines!(ax, hrough, linestyle=:dot, color=:black, label="Altura da rugosidade")
    end

    axislegend(ax, position=:lt)
    return fig
    
    
end



function calcpowerprofile!(fig, z, u; zref=1.0, hrough=nothing, zunit="mm", vunit="m/s")

    @assert length(z) == length(u)  "Tamanhos de `z` e `u` devem ser os mesmos!"
    
    npts = length(z)
    


    # Interval slider:
    isl = IntervalSlider(fig[1,2], range = 1:npts, startvalues=(1,npts),
                         horizontal=false)
    cc = fill(:blue, npts)
    color = lift(isl.interval) do ii
        idx = ii[1]:ii[2]
        cc .= :blue
        cc[idx] .= :red
        cc
    end
    fit = lift(isl.interval) do ii
        idx = ii[1]:ii[2]
        powerprofile(z[idx], u[idx], zref)
    end
    
    powerlab = lift(fit) do f
        zref = round(f.zref, sigdigits=3)
        uref = round(f.uref, sigdigits=3)
        p = round(f.p, sigdigits=2)
        "Lei potencial  u = $uref×(z/$zref)^$p"
    end
    ucalc = lift(fit) do f
        f.(z)
    end
    
    ax = Axis(fig[1,1], xlabel="Velocidade ($vunit)", ylabel="Altura ($zunit)",
              yscale=log10, xscale=log10, title=powerlab)
    fmeas = scatter!(ax, u, z, color=color, label="Perfil medido")
    ffit = lines!(ax, ucalc, z, color=:red, linewidth=2, label="Ajuste do perfil")
    
    
    if !isnothing(zref)
        hlines!(ax, zref, linestyle=:dash, color=:black, label="Altura de referência")
        
    end
    if !isnothing(hrough)
        hlines!(ax, hrough, linestyle=:dot, color=:black, label="Altura da rugosidade")
    end

    axislegend(ax, position=:lt)
    return fig
    
    
end



function calcprofilefp!(fig, z, fp; zref=1.0, zunit="mm")

    @assert length(z) == length(fp)  "Tamanhos de `z` e `fp` devem ser os mesmos!"
    
    npts = length(z)
    


    # Interval slider:
    isl = IntervalSlider(fig[1,2], range = 1:npts, startvalues=(1,npts),
                         horizontal=false)
    cc = fill(:blue, npts)
    color = lift(isl.interval) do ii
        idx = ii[1]:ii[2]
        cc .= :blue
        cc[idx] .= :red
        cc
    end
    fit = lift(isl.interval) do ii
        idx = ii[1]:ii[2]
        fit = powerprofile(z[idx], fp[idx], 1.0)
        fit
    end
    
    powerlab = lift(fit) do f
        fp0 = round(f(zref), sigdigits=4)
        "Fator de pressão dinâmica fₚ = $fp0"
    end
    fpcalc = lift(fit) do f
        f.(z)
    end
    
    ax = Axis(fig[1,1], xlabel="fₚ = Δp/Δp_ref", ylabel="Altura ($zunit)",
              yscale=log10, xscale=log10, title=powerlab)
    fmeas = scatter!(ax, fp, z, color=color, label="Perfil medido")
    ffit = lines!(ax, fpcalc, z, color=:red, linewidth=2, label="Ajuste do perfil")
    
    
    if !isnothing(zref)
        hlines!(ax, zref, linestyle=:dash, color=:black, label="Altura de referência")
        
    end

    axislegend(ax, position=:lt)
    return fig
    
    
end

