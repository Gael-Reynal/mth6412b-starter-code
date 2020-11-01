### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 25c2ca00-1b6d-11eb-26d5-35ff69b37966
using PlutoUI

# ╔═╡ 7c957680-1b6c-11eb-3bc0-315c8874ae39
using Test

# ╔═╡ 22431920-1b6d-11eb-1376-177eeadcee26
begin
	include("node.jl")
	include("edge.jl")
	include("graph.jl")
	include("queue.jl")
	include("heuristics.jl")
	include("prim.jl")
	include("creategraph.jl")
	include("read_stsp.jl")
	include("main.jl")
	include("testprim.jl")
end

# ╔═╡ d8a78540-1b6b-11eb-2c7d-dd5c13a7815b
md"# **Rapport de projet MTH6412B phase 3**
*Travail réalisé par Hugo BRETON et Gaël REYNAL*

*Remis au Pr Dominique ORBAN*

*Novembre 2020*

*code disponible à l'adresse : https://github.com/Gael-Reynal/mth6412b-starter-code.git*

## Remarque préliminaire

On a tout d'abord modifié la structure de donnée `Node` en lui ajoutant un attribut `value::Union{Int,Float64}` (`Float64` pour permettre les infinis). Cet attribut sera particulièrement utile lorsqu'il s'agira de comparer des noeuds (ex: attribut de priorité dans une file, ordre de passage dans une tournée, rang dans une arborescence binaire, distance dans l'algorithme de Dijkstra, etc). Du fait de sa versatilité, on ne manquera pas de préciser en commentaire ou en définition de fonction le sens donné à cet attribut dans ce cas précis.
On a également implémenté la fonction `is_less(n1::AbstractNode, n2::AbstractNode)` qui implémente l'opérateur `<` pour les noeuds, et qui renvoie `True` si n1.value < n2.value.
"

# ╔═╡ 8996aba0-1c26-11eb-1db3-ebbe71d36a15
md"## Heuristique d'accélération de la recherche de la racine d'un noeud dans un graphe

# Compression des chemins

On a implémenté comme suit l'heuristique de compression des chemins :
"

# ╔═╡ 44d01e80-1b6c-11eb-257c-59e52060b6da
with_terminal() do
	open("heuristics.jl","r") do file
	lines=readlines(file)
		for i in 12:23
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
	open("heuristics.jl","r") do file
	lines=readlines(file)
		for i in 25:43
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 4cc56800-1c27-11eb-28c9-5d368320a436
md" L'implémentation a été vérifiée par les tests suivants :
"

# ╔═╡ 602853d0-1c27-11eb-0797-67ae6fb38e3a
md" **INSERER LES TESTS D'UNION PAR LE RANG**"

# ╔═╡ 682ca26e-1c27-11eb-2d16-03e68885f39e
md" La question se pose de savoir quel peut-être le rang d'un noeud. On peut déjà remarquer qu'en fusionnant deux composantes connexes (disons deux noeuds, quitte à assimiler une composante connexe à sa racine), on a une augmentation du rang d'au plus 1 (cas où les deux noeuds sont de même rang). De plus, tous les noeuds commencent initialement avec un rang de 0. De ces deux postulats, on déduit qu'on aura bien un rang d'au plus $|S|-1$ pour un noeud.

Mais il est possible de faire mieux : montrons que le rang d'un noeud est toujours inférieur à $\lfloor log_2(|S|) \rfloor$.

Soit $G$ un graphe contenant $|S|$ noeuds tous de rang 0. On va procéder à des fusions de composantes connexes pour augmenter le rang de leur racine jusqu'à une valeur $k$. On note alors $N_k$ le nombre de noeuds minimal que doit contenir une composante connexe pour que sa racine soit de rang $k$.
Montrons par récurrence sur $k$ que $N_k = 2^k$.

_Initialisation_ : Initialement, tous les noeuds ont un rang de 0 et sont leur propre racine. On a donc bien $N_0 = 1 = 2^0$.

_Hérédité_ : On suppose la propriété vraie au rang $k-1$ et on souhaite la montrer au rang $k$. Par construction de l'algorithme, la racine d'une composante connexe issue de la fusion de deux composantes plus petites est de rang $k$ dans deux cas seulement :
* L'une des composantes était de rang $k$ et l'autre de rang inférieur. Mais alors, cette composante contenait déjà au moins $N_k$ noeuds. On écarte donc ce cas.
* Les deux composantes étaient de rang $k-1$. On se place dans le cas minimal : on suppose que ces deux composantes comportent chacune $N_{k-1}$ noeuds. Alors, leur fusion est, elle aussi, minimale et comporte donc $N_k$ noeuds. Or cette nouvelle composante comporte donc $2*N_{k-1} = 2*2^{k-1} = 2^k$ noeuds, par hypothèse de récurrence. On a vérifié l'hypothèse au rang $k$.

_Conclusion_ : Par récurrence, on a montré qu'une composante connexe dont la racine est de rang $k$ comporte au moins $2^k$ noeuds.

On applique cette propriété pour $k_1=\lfloor log_2(|S|) \rfloor$ et $k_2=\lfloor log_2(|S|) \rfloor +1$
On a alors $N_{k_1} = 2^{\lfloor log_2(|S|) \rfloor} \le 2^{log_2(|S|)} = |S|$ et $N_{k_2} = 2^{\lfloor log_2(|S|) \rfloor +1} > 2^{log_2(|S|)} = |S|$ Il est donc impossible d'avoir un noeud de rang $\lfloor log_2(|S|) \rfloor +1$ car cela demande plus de noeuds qu'il n'y en a dans le graphe.

On aboutit donc à ce que l'on souhaitait montrer : le rang d'un noeud est toujours inférieur à $\lfloor log_2(|S|) \rfloor$.
"

# ╔═╡ d81f70d0-1c2c-11eb-033b-17b0b7f61f3d
md"## Algorithme de Prim
# Implémentation
On a implémenté comme suit l'algorithme de Prim en procédant par étapes :
* On crée une file de priorité dans laquelle on placera tous les noeuds restants à visiter. l'attribut de priorité est `value`
* On crée un graphe résultat initialement vide d'arêtes et de noeuds
* On initialise tous les noeuds : `parent` à `nothing`, `value` à `Inf`. On ajoute également ces noeuds au graphe résultat et à la liste de priorité.
* On initialise les attributs de la source

Puis, tant que des noeuds ne sont pas connectés, on itère le procédé suivant :
* On parcourt les arêtes en quête d'une arête légère connectant un noeud isolé au sous-arbre en mettant à jour l'attribut `value` des noeuds
* On connecte le noeud de plus bas attribut `value` en ajoutant l'arête légère au graphe. On applique en même temps la compression des chemins.
"

# ╔═╡ f336b680-1c2c-11eb-2b34-a5c6949024ac
with_terminal() do
	open("prim.jl","r") do file
	lines=readlines(file)
		for i in 1:67
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ ac2c7480-1c2e-11eb-0d28-379d5b29cbee
md" Afin de vérifier l'implémentation, les tests suivants ont été réalisés :"

# ╔═╡ c9856cd0-1c2e-11eb-3531-733daaa4dd4f
md" **INSERER LES TESTS DE PRIM**"

# ╔═╡ d30e3890-1c2e-11eb-0c79-850eb41f0fa4
md"# Applications
L'algorithme a été appliqué à l'exemple des notes de cours comme suit :"

# ╔═╡ ecb43b00-1c2e-11eb-209a-1dbcb8c47a76
with_terminal() do
	open("main.jl","r") do file
	lines=readlines(file)
		for i in 10:38
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 2063bca0-1c2f-11eb-1db6-8dc51026b586
md" et renvoie le résultat suivant :"

# ╔═╡ 293b39c0-1c2f-11eb-1b82-7d6da78b2a0e
with_terminal() do
	A=Node("a","A",nothing,Inf)
	B=Node("b","B",nothing,Inf)
	C=Node("c","C",nothing,Inf)
	D=Node("d","D",nothing,Inf)
	E=Node("e","E",nothing,Inf)
	F=Node("f","F",nothing,Inf)
	G=Node("g","G",nothing,Inf)
	H=Node("h","H",nothing,Inf)
	I=Node("i","I",nothing,Inf)

	AB=Edge([A,B],4)
	AH=Edge([A,H],8)
	BC=Edge([B,C],8)
	BH=Edge([B,H],11)
	CD=Edge([C,D],7)
	CF=Edge([C,F],4)
	CI=Edge([C,I],2)
	DE=Edge([D,E],9)
	DF=Edge([D,F],14)
	EF=Edge([E,F],10)
	FG=Edge([F,G],2)
	GH=Edge([G,H],1)
	GI=Edge([G,I],6)
	HI=Edge([H,I],7)

	G=Graph("G",[A,B,C,D,E,F,G,H,I],[AB,AH,BC,BH,CD,CF,CI,DE,DF,EF,FG,GH,GI,HI])

	P1 = prim(G,A)
	show(P1)
end

# ╔═╡ 4f671b50-1c2f-11eb-3e8d-77f8e46c333b
md" ce qui correspond bien à l'arbre de recouvrement attendu"

# ╔═╡ 6aa793e2-1c2f-11eb-1297-fbc895d9dfb4
md"L'algorithme a également été appliqué aux instances de tsp symétriques. A titre indicatif, on donne ici le résultat renvoyé pour l'instance swiss42.tsp
"

# ╔═╡ 851fe500-1c30-11eb-3686-f751a99e1321
with_terminal() do
	test_prim("swiss42")
end

# ╔═╡ aecbeca0-1c30-11eb-248a-41882f2b04bc
md"Pour tester le programme sur d'autres instances, on a fourni le code suivant :"

# ╔═╡ c2133a20-1c30-11eb-2651-a172fefe4ae0
with_terminal() do
	open("testprim.jl","r") do file
	lines=readlines(file)
		for i in 10:27
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ d606a620-1c30-11eb-2954-cb052f28d768
md" Cette fonction prend en argument une chaîne de caractère renseignant le nom du fichier sans l'extension .tsp. Par exemple, `test_prim(\"swiss42\")` applique l'algorithme de prim à l'instance `swiss42.tsp`. 

Afin de faciliter l'utilisation, on a ajouté la ligne d'exécution `test_prim(ARGS[1])` qui va exécuter la fonction en considérant le premier argument de la ligne entrée dans l'invite de commande comme paramètre. Par exemple, en entrant `julia testprim.jl swiss42` dans l'invite de commande, on applique la fonction à l'instance `swiss42.tsp` (sous réserve bien sûr que les fichiers soient localisés au bon endroit).
"

# ╔═╡ Cell order:
# ╠═22431920-1b6d-11eb-1376-177eeadcee26
# ╠═25c2ca00-1b6d-11eb-26d5-35ff69b37966
# ╠═7c957680-1b6c-11eb-3bc0-315c8874ae39
# ╟─d8a78540-1b6b-11eb-2c7d-dd5c13a7815b
# ╟─8996aba0-1c26-11eb-1db3-ebbe71d36a15
# ╟─44d01e80-1b6c-11eb-257c-59e52060b6da
# ╟─4012c810-1b6d-11eb-2359-0177f7165cac
# ╟─a1fb2c6e-1b6d-11eb-3383-59299459c799
# ╟─b1fec0a0-1b6d-11eb-0b22-3d6f20daa594
# ╟─e51f48b0-1b6d-11eb-0052-07b2534037c6
# ╟─4cc56800-1c27-11eb-28c9-5d368320a436
# ╟─602853d0-1c27-11eb-0797-67ae6fb38e3a
# ╟─682ca26e-1c27-11eb-2d16-03e68885f39e
# ╟─d81f70d0-1c2c-11eb-033b-17b0b7f61f3d
# ╟─f336b680-1c2c-11eb-2b34-a5c6949024ac
# ╟─ac2c7480-1c2e-11eb-0d28-379d5b29cbee
# ╟─c9856cd0-1c2e-11eb-3531-733daaa4dd4f
# ╟─d30e3890-1c2e-11eb-0c79-850eb41f0fa4
# ╟─ecb43b00-1c2e-11eb-209a-1dbcb8c47a76
# ╟─2063bca0-1c2f-11eb-1db6-8dc51026b586
# ╟─293b39c0-1c2f-11eb-1b82-7d6da78b2a0e
# ╟─4f671b50-1c2f-11eb-3e8d-77f8e46c333b
# ╟─6aa793e2-1c2f-11eb-1297-fbc895d9dfb4
# ╟─851fe500-1c30-11eb-3686-f751a99e1321
# ╟─aecbeca0-1c30-11eb-248a-41882f2b04bc
# ╠═c2133a20-1c30-11eb-2651-a172fefe4ae0
# ╟─d606a620-1c30-11eb-2954-cb052f28d768
