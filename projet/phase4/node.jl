import Base.show
import Base.isless

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
  value::Union{Int,Float64}
  deg::Int
  pen::Union{Float64,Int}
end

Node{T}(data::T;
  name::String="",
  par::Union{Node{T},Nothing}=nothing,
  value::Union{Int,Float64}=0,
  deg::Int=0,
  pen::Union{Float64,Int}=0) where T = Node(data,name,par,value,deg,pen)

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name`, `par` et `data`.
# l'attribut `value` pourra représenter un rang, une distance ou tout autre donnée numérique utile à la comparaison de noeuds
# L'attribut `deg` permettra de représenter le degré du noeud dans un graphe
# L'attribut `pen` représente la pénalité du noeud dans l'algorithme de Held et Karp

### Getters ###

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie le parent du noeud"""
par(node::AbstractNode) = node.par

"""Renvoie la valeur du noeud"""
value(node::AbstractNode) = node.value

"""Renvoie le degré du noeud"""
deg(node::AbstractNode) = node.deg

"""Renvoie la pénalité du noeud"""
pen(node::AbstractNode) = node.pen

### Setters ###

"""Setter du nom d'un noeud"""
function set_name!(node::Node{T}, n::String) where T
  node.name=n
  node
end

"""Setter du parent d'un noeud"""
function set_parent!(node::Node{T}, p::Union{Node{T},Nothing}) where T
  node.par = p
  node
end

"""Setter de la valeur d'un noeud"""
function set_value!(node::Node{T},value::Union{Int,Float64}) where T
  node.value=value
  node
end

"""Setter du degré d'un noeud"""
function set_deg!(node::Node{T},d::Int) where T
  node.deg = d
  node
end

"""Setter de la pénalité d'un noeud"""
function set_pen!(node::Node{T},p::Union{Float64,Int}) where T
  node.pen = p
  node
end

### Affichage ###

"""Affiche les données principales d'un noeud."""
function show(node::AbstractNode)
  if node.par==nothing
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par)
  else
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par.name)
  end
end

"""Affichage l'intégralité des caractéristiques d'un noeud"""
function show_full(node::AbstractNode)
  if node.par==nothing
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par, ", value: ", node.value, ", degree: ", node.deg, ", penalty: ", node.pen)
  else
    println("Node ", name(node), ", data: ", data(node), ", parent: ", node.par.name, ", value: ", node.value, ", degree: ", node.deg, ", penalty: ", node.pen)
  end
end

### Comparaison entre noeuds ###
isless(n1::AbstractNode, n2::AbstractNode) = value(n1) < value(n2)