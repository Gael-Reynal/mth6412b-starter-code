import Base.show

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        arête = Edge((Node1, Node2), 12)

"""
mutable struct Edge{T} <: AbstractEdge{T}
  limits::Tuple{Node{T},Node{T}}                                
  weight::Int64                                
end

# on présume que toutes les arêtes dérivant d'AbstractEdge
# posséderont des champs `weight` et `limits`.

"""Renvoie le nom des noeuds aux extrémités de l'arête."""
limits(edge::AbstractEdge)=(edge.limits[1].name,edge.limits[2].name)

"""Renvoie le poids de l'arête."""
weight(edge::AbstractEdge) = edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("Noeuds liés: ", limits(edge),", weight: ", weight(edge))
end
