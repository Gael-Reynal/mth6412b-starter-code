### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 22431920-1b6d-11eb-1376-177eeadcee26
using Test

# ╔═╡ 25c2ca00-1b6d-11eb-26d5-35ff69b37966
using PlutoUI

# ╔═╡ 7c957680-1b6c-11eb-3bc0-315c8874ae39
include("node.jl")

# ╔═╡ a44efcee-1b6c-11eb-1fd3-07d64d1f9832
include("weightnode.jl")

# ╔═╡ f44e27c0-1b6d-11eb-3ad0-b1b4ea413222
include("ranknode.jl")

# ╔═╡ 85be47f0-1b6c-11eb-01d7-45546a23ea9f
include("edge.jl")

# ╔═╡ 9cf71af0-1b6c-11eb-385c-d3c7a99ec50f
include("graph.jl")

# ╔═╡ c6882080-1b6c-11eb-254d-49a9550c537c
include("nodequeue.jl")

# ╔═╡ c9f97980-1b6c-11eb-3ba9-0bfc76fe35d6
include("ranknode.jl")

# ╔═╡ ce79aa70-1b6c-11eb-1803-4335cdc9331a
include("creategraph.jl")

# ╔═╡ d42981c0-1b6c-11eb-36a8-7932a488813a
include("prim.jl")

# ╔═╡ d6b47260-1b6c-11eb-1633-b9fef2b79556
include("find_root_comp.jl")

# ╔═╡ dcbace20-1b6c-11eb-388d-3b856576fede
include("rankmerge.jl")

# ╔═╡ e0960c80-1b6c-11eb-039d-1b1011f81230
include("read_stsp.jl")

# ╔═╡ e4595610-1b6c-11eb-0618-c320835b78bf
include("main.jl")

# ╔═╡ d8a78540-1b6b-11eb-2c7d-dd5c13a7815b
md"# **Rapport de projet MTH6412B phase 3**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Novembre 2020*

*code disponible à l'adresse : https://github.com/Gael-Reynal/mth6412b-starter-code.git*

## Heuristique d'accélération de la recherche de la racine d'un noeud dans un graphe

# Compression des chemins

On a implémenté comme suit l'heuristique de compression des chemins :
"

# ╔═╡ 44d01e80-1b6c-11eb-257c-59e52060b6da
with_terminal() do
	open("find_root_comp.jl","r") do file
	lines=readlines(file)
		for i in 1:12
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 4012c810-1b6d-11eb-2359-0177f7165cac
md" Dans cette fonction, on considère qu'un noeud est une racine s'il est son propre parent ou si son parent est `nothing`. Le déroulement est simple : on garde en mémoire tous les noeuds visités avant d'arriver à la racine. Une fois la racine trouvée, on en fait le parent direct de tous ces noeuds.
Afin de vérfier notre implémentation, on a réalisé les tests suivants sur des cas limites.
"

# ╔═╡ a1fb2c6e-1b6d-11eb-3383-59299459c799
md" **INSERER LES TESTS DE COMPRESSION DES CHEMINS**"

# ╔═╡ b1fec0a0-1b6d-11eb-0b22-3d6f20daa594
md"# Union par le rang
On a également implémenté comme suit l'union par le rang :
"

# ╔═╡ e51f48b0-1b6d-11eb-0052-07b2534037c6
with_terminal() do
	open("rankmerge.jl","r") do file
	lines=readlines(file)
		for i in 1:12
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ Cell order:
# ╠═22431920-1b6d-11eb-1376-177eeadcee26
# ╠═25c2ca00-1b6d-11eb-26d5-35ff69b37966
# ╠═7c957680-1b6c-11eb-3bc0-315c8874ae39
# ╠═a44efcee-1b6c-11eb-1fd3-07d64d1f9832
# ╠═f44e27c0-1b6d-11eb-3ad0-b1b4ea413222
# ╠═85be47f0-1b6c-11eb-01d7-45546a23ea9f
# ╠═9cf71af0-1b6c-11eb-385c-d3c7a99ec50f
# ╠═c6882080-1b6c-11eb-254d-49a9550c537c
# ╠═c9f97980-1b6c-11eb-3ba9-0bfc76fe35d6
# ╠═ce79aa70-1b6c-11eb-1803-4335cdc9331a
# ╠═d42981c0-1b6c-11eb-36a8-7932a488813a
# ╠═d6b47260-1b6c-11eb-1633-b9fef2b79556
# ╠═dcbace20-1b6c-11eb-388d-3b856576fede
# ╠═e0960c80-1b6c-11eb-039d-1b1011f81230
# ╠═e4595610-1b6c-11eb-0618-c320835b78bf
# ╟─d8a78540-1b6b-11eb-2c7d-dd5c13a7815b
# ╟─44d01e80-1b6c-11eb-257c-59e52060b6da
# ╟─4012c810-1b6d-11eb-2359-0177f7165cac
# ╟─a1fb2c6e-1b6d-11eb-3383-59299459c799
# ╟─b1fec0a0-1b6d-11eb-0b22-3d6f20daa594
# ╠═e51f48b0-1b6d-11eb-0052-07b2534037c6
