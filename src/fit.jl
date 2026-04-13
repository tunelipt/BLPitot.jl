export powerprofile, logprofile, LogProfile, PowerProfile

"""
Fits a straight line through a set of points, `y = a₁ + a₂ * x`
"""
function linearfit(x, y)
    
    @assert length(x) == length(y) "Incompatible sizes!"

    sx = sum(x)
    sy = sum(y)

    m = length(x)

    sx2 = zero(sx.*sx)
    sy2 = zero(sy.*sy)
    sxy = zero(sx*sy)

    for i = 1:m
        sx2 += x[i]*x[i]
        sy2 += y[i]*y[i]
        sxy += x[i]*y[i]
    end

    a0 = (sx2*sy - sxy*sx) / ( m*sx2 - sx*sx )
    a1 = (m*sxy - sx*sy) / (m*sx2 - sx*sx)

    return (a0, a1)
    
end

"Fits a log function through a set of points: `y = a₁+ a₂*log(x)`"
logfit(x, y) = linearfit(log.(x), y)


"Fits a power law through a set of points: `y = a₁*x^a₂`"
function powerfit(x, y)
    fit = linearfit(log.(x), log.(y))
    (exp(fit[1]), fit[2])
end
    


struct LogProfile
    z0::Float64
    us::Float64
    kappa::Float64
    d::Float64
end
Base.broadcastable(p::LogProfile) = Ref(p)
(p::LogProfile)(z) = (p.us/p.kappa) * log( (z - p.d) / p.z0 )
    
"""
`logprofile(z, u, kappa=0.4)`

Fit a logarightmic profile through the boundary layer data:

```math
u/uₜ = 1/κ ⋅ ln ( z / z₀ )
```

Where ``uₜ`` is the shear velocity and ``z₀`` is the roughness length.

The function returns `z₀` and `uₜ` 
"""
function logprofile(z, u, κ=0.4)
    a₀, a₁ = logfit(z, u)

    uₜ = a₁*κ

    z₀ = exp(-a₀ / a₁)

    return LogProfile(z₀, uₜ, κ, 0.0)
end

struct PowerProfile
    p::Float64
    uref::Float64
    zref::Float64
end
Base.broadcastable(p::PowerProfile) = Ref(p)
(p::PowerProfile)(z) = p.uref * (z / p.zref)^p.p

"""
`powerprofile(z, u, zref=1)`  

Fit a power profile through the boundary layer data:

```math
u = b ⋅ (z / zref)ᵖ
```

Where `zref` is the reference height, `b` is the velocity at the reference height.

This function returns a tuple whose first element is the power exponent `p` and the
second element is the 

The function returns `z₀` and `uₜ` 
"""
function powerprofile(z, u, zref=1)

    uref, p = powerfit(z./zref, u)
    
    return PowerProfile(p, uref, zref)
end
