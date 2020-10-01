import Base.show

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        noeud1 = Node("Kirk", "guitar")
        noeud2 = Node("Lars", 2)
        edge = Edge([noeud1, noeud2], 12)

"""
mutable struct Edge{T} <: AbstractEdge{T}
  limits::Vector{Node{T}}
  weight::Int64
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `limits` et `weight`.

Edge{T}() where T = Edge(Node{T}[],0)

"""Renvoie les noms des parents de l'arête."""
function limits(edge::AbstractEdge)
    lim=String[]
    for node in edge.limits
        push!(lim,node.name)
    end
    return lim
end

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Permet de changer le poids de l'arête"""
function weight!(edge::AbstractEdge,weight::Int64)
  edge.weight=weight
  edge
end

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("L'arête relie les noeuds ", limits(edge), " avec un poids de ", weight(edge))
end
