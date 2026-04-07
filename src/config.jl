# Configuração do ensaio


const process_path = "process"
const scripts_path = "scripts"


mutable struct BLPitotModule <: AbstractWTModule
    project::WTProject
    path::String
    name::Symbol
    folders::Dict{Symbol,String}
    toml::TDict
    repository::String
end

