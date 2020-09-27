using Test

include("main.jl")

fic1 = "brazil58.tsp" 
fic2 = "swiss42.tsp"
fic3 = "gr21.tsp"

graph_braz = create_graph("g", fic1)
graph_swiss = create_graph("g", fic2)
graph_groet = create_graph("g", fic3)

println(@test typeof(graph_braz) == Graph{Array{Float64, 1}})
println(@test nb_nodes(graph_braz) == 58)
println(@test nb_edges(graph_braz) == 58*57/2)

println(@test typeof(graph_swiss) == Graph{Array{Float64, 1}})
println(@test nb_nodes(graph_swiss) == 42)
println(@test nb_edges(graph_swiss) == 42*42)

println(@test typeof(graph_groet) == Graph{Array{Float64, 1}})
println(@test nb_nodes(graph_groet) == 21)
println(@test nb_edges(graph_groet) == 22*21/2)


