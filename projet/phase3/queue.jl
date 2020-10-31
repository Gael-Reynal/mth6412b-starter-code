import Base.length
import Base.push!
import Base.show
import Base.minimum

"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end

"""File de priorité."""
mutable struct PriorityQueue{T} <: AbstractQueue{T}
    items::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

### Getters ###
length(q::AbstractQueue) = length(q.items)

### Méthodes ###

"""Ajoute un élément à la file"""
function push!(q::PriorityQueue{T}, item::T) where T
    push!(q.items,item)
end

minimum(q::AbstractQueue) = minimum(q.items)

function popfirst_min!(q::AbstractQueue)
    lowest=minimum(q)
    idx = findall(x -> x == lowest, q.items)[1]
    lowest=q.items[idx]
    deleteat!(q.items, idx)
    lowest
end

is_empty(q::AbstractQueue) = (length(q)==0)

"""Affiche une file de priorité"""
function show(q::PriorityQueue)
    println("La file comporte ",length(q.items)," éléments.")
    for k in q.items
        show(k)
    end
end