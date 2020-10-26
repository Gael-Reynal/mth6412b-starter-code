"""Renvoie la racine du noeud placé en paramètre. Réalise également l'union par le rang"""
function find_root_rank(n::Node{T}) where T
    if n.par==n
        return n
    else
        return find_root(n.par)
    end
end