"""Renvoie la racine du noeud placé en paramètre"""
function find_root(n::Node{T})
    if n.par==n
        return n
    else
        return find_root(n.par)
    end
end

"""Applique l'algorithme Kruskal pour renvoyer un arbre 
de recouvrement minimal du graphe en paramètre"""
function kruskal(graph::Graph{T})
    res=Graph(string("min_tree_",graph.name),graph.nodes,Edge{T}[])
    sort!(graph.edges, by=weight)

    for edge in graph.edges
        r1=find_root(edge.limits[1])
        r2=find_root(edge.limits[1])
        if r1!=r2
            r2.par=r1
            push!(res.edges,edge)
        end
    end
    return res
end