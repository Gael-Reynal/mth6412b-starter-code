### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ c5396f50-3d6c-11eb-2f67-3d36113b9bd7
begin
	using PlutoUI
	using Test
	using Random
	using FileIO
	using Images
	using ImageView
	using ImageMagick
end

# ╔═╡ c09d7900-3d6c-11eb-20b3-0fd4a5163ecd
begin
	include("node.jl")
	include("edge.jl")
	include("graph.jl")
	include("queue.jl")
	include("heuristics.jl")
	include("prim.jl")
	include("kruskal.jl")
	include("creategraph.jl")
	include("read_stsp.jl")
	include("onetree.jl")
	include("rsl.jl")
	include("hk.jl")
	include("graphplot.jl")
	include("tools.jl")
end

# ╔═╡ 6110b7e0-3d6c-11eb-2711-7b0ce5bb830a
md"# **Rapport de projet MTH6412B phase 5**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Novembre 2020*

*code disponible à l'adresse : https://github.com/Gael-Reynal/mth6412b-starter-code.git*

## Application des algorithmes de TSP à la reconstruction d'images

On considère une image comme une succession colonne de pixels. On imagine que cette image a été passée dans une sorte de déchiqueteuse ayant mélangé ces colonnes. On cherche ici à reconstruire cette image, c'est à dire à réagencer les colonnes dans l'ordre pré-déchiqueteuse.

On peut montrer qu'il est possible de réaliser ce réangencement en utilisant un algorithme de plus court chemin. On pose d'abord la distance entre deux pixels comme la somme des écarts entre leurs trois composantes (RGB), puis la distance entre colonnes comme la somme des distances entre les pixels situés sur la même ligne. On obtient ainsi une matrice des distances entre les colonnes produisant une instance de tsp symétrique. En cherchant une tournée de moindre coût, on va ainsi juxtaposer les colonnes en minimisant la distance parcourue (donc en positionnant côte à côte des colonnes très similaires), ce qui permettra de reconstituer l'image.

Les quelques fonctions utiles à une telle opération ont été données comme suit
"

# ╔═╡ 1a782370-3d6e-11eb-1106-5fb6f12ff119
with_terminal() do
	open("tools.jl","r") do file
	lines=readlines(file)
		for i in 1:87
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 7e07a820-3d6e-11eb-0ec3-2354cbc83a5d
md" On a décidé ici d'utiliser l'algorithme RSL avec recherche d'Arbres de recouvrement minimaux par l'algorithme de Prim. En effet, si cet algorithme offre de moins bonnes performances que l'algorithme HK par exemple, il s'exécute en un temps raisonnable (de l'ordre de 2min pour une image) là où plusieurs heures sont requises pour une exécution de l'algorithme HK. Cette option offre donc le meilleur rapport Qualité de solution/temps de calcul.

Les images sont donc reconstruites à l'aide des opérations suivantes :
"

# ╔═╡ e8fc0720-3d6e-11eb-114c-595d096c2476
with_terminal() do
	open("main.jl","r") do file
	lines=readlines(file)
		for i in 18:78
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 06bc25b0-3d6f-11eb-3c33-e9e235aba496
md" Les images reconstruites sont présentes dans le dossier `/Résultats/Pictures` et les tournées correspondantes dans `/Résultats/Tours`. Les images initiales mélangées sont regroupées dans le dossier `shuffled` et les instances de tsp correspondantes dans `instances`.
On peut remarquer que la reconstruction des images est cependant imparfaites. On observe des coupures et des retournements de l'image. La raison en est simple : la tournée trouvée n'est pas optimale (d'où les coupures) et l'instance est symétrique. Cette symétrie de l'instance fait que l'image et sa version retournée (en 'miroir') sont de même poids. il est donc normal d'observer ces retournements.
On note tout de même que le pourcentage de colonnes mal placées est de l'ordre de 5%, ce qui est un excellent résultat.
"

# ╔═╡ Cell order:
# ╟─c5396f50-3d6c-11eb-2f67-3d36113b9bd7
# ╟─c09d7900-3d6c-11eb-20b3-0fd4a5163ecd
# ╟─6110b7e0-3d6c-11eb-2711-7b0ce5bb830a
# ╟─1a782370-3d6e-11eb-1106-5fb6f12ff119
# ╟─7e07a820-3d6e-11eb-0ec3-2354cbc83a5d
# ╟─e8fc0720-3d6e-11eb-114c-595d096c2476
# ╟─06bc25b0-3d6f-11eb-3c33-e9e235aba496
