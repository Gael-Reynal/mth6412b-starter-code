include("node.jl")

"""Trouve la racine d'un noeud"""
function find_root(node::Node{T}) where T
    if node.par == nothing || node.par==node
        return node
    else
        return find_root(node.par)
    end
end

"""Trouve la racine d'un noeud et applique la compression des chemins"""
function find_root_compressed(node::Node{T}, path::Vector{Node{T}}=Node{T}[]) where T
    if node.par == nothing || node.par == node
        for n in path
            set_parent!(n,node)
        end
        return node
    else
        push!(path,node)
        return find_root_compressed(node.par,path)
    end
end

"""Fusionne deux composantes connexes en utilisant l'union par le rang.
Ici, l'attribut `value` d'un noeud correspondra donc à son rang"""
function rank_merge(n1::Node{T},n2::Node{T}) where T
    r1=find_root(n1)
    r2=find_root(n2)
    if r1 == r2
        return ("Même composante")
    elseif r1.value == r2.value
        set_value!(r1,r1.value+1)
        set_parent!(r2,r1)
        return r1
    elseif r1 > r2
        set_parent!(r2,r1)
        return r1
    else
        set_parent!(r1,r2)
        return r2
    end
end
