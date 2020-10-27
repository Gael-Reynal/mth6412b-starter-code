import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node("James", [π, exp(1)])
        noeud = Node("Kirk", "guitar")
        noeud = Node("Lars", 2)

"""
mutable struct Node{T} <: AbstractNode{T}
  data::T
  name::String
  par::Union{Node{T},Nothing}
  min_weight::Union{Int,Float64}
end

Node{T}(data::T) where T = Node(data,"",nothing,Inf)

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name`, `par`, `data` et `minweight`

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie le parent du noeud"""
par(node::AbstractNode) = node.par

"""Renvoie le poids minimal d'un noeud"""
min_weight(node::AbstractNode) = node.min_weight

"""Setter du parent d'un noeud"""
function set_parent!(node::Node{T}, p::Node{T}) where T
  node.par = p
  node
end

"""Setter du poids d'un noeud"""
function set_min_weight!(node::Node{T}, w::Int) where T
  node.min_weight = w
  node
end

"""Affiche un noeud."""
function show(node::AbstractNode)
  if node.par==nothing
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par, ", poids: ", node.min_weight)
  else
    println("Node ", name(node), ", data: ", data(node), ", parent:", node.par.name, ", poids: ", node.min_weight)
  end
end
