"""Trouve la racine d'un noeud et applique la compression des chemins"""
function find_root_compressed(n::Node{T},path::Vector{Node{T}}=Node{T}[]) where T
    if n.par==n
        for node in path
            set_parent!(node,n)
        end
        return n
    else
        push!(path,n)
        find_root_compressed(n.par,path)
    end
end