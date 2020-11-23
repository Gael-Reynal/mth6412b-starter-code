### A Pluto.jl notebook ###
# v0.12.11

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
	include("test.jl")
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
with_terminal() do
	open("test.jl","r") do file
	lines=readlines(file)
		for i in 8:17
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ cae899b0-1d07-11eb-08fd-1fa36280c232
with_terminal() do
	A=Node("a","A",nothing,0)
    B=Node("b","B",A,0)
    C=Node("c","C",B,0)
    D=Node("d","D",B,0)

    println(@test find_root_compressed(A)==A)
    println(@test find_root_compressed(B)==A)
    println(@test find_root_compressed(C)==A)
    println(@test C.par==A)
    println(@test D.par==B)
end

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
with_terminal() do
	open("test.jl","r") do file
	lines=readlines(file)
		for i in 19:28
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ fd221d20-1d07-11eb-10cf-6d8504e57e14
with_terminal() do
	A=Node("a","A",nothing,0)
    B=Node("b","B",A,0)
    C=Node("c","C",B,0)
    D=Node("d","D",B,0)
    E=Node("d","D",nothing,1)
    F=Node("d","D",nothing,1)
	
	println("Union par le rang")
    println(@test rank_merge(A,D)=="Même composante")

    rank_merge(A,E)
    println(@test A.value==0)
    println(@test E.value==1)
    rank_merge(E,F)
    println(@test E.value==2)
end

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
		for i in 1:63
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ ac2c7480-1c2e-11eb-0d28-379d5b29cbee
md" Afin de vérifier l'implémentation, les tests suivants ont été réalisés :"

# ╔═╡ c9856cd0-1c2e-11eb-3531-733daaa4dd4f
with_terminal() do
	open("test.jl","r") do file
	lines=readlines(file)
		for i in 30:160
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ 6e8388f0-1d08-11eb-1b19-a1b49c840550
with_terminal() do
	# Algorithme de Prim : cas limites
	A=Node("a","A",nothing,Inf)
    println("Algorithme de Prim")
    G0=Graph("",[A],Edge{String}[])
    println(@test isequal(prim(G0,A),G0))

    # Test 1 -------------------------------------------------------

    println("Exemple des notes de cours")
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
    AH=Edge([A,H],7)
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

    G1 = Graph("G1",[A,B,C,D,E,F,G,H,I],[AB,AH,BC,BH,CD,CF,CI,DE,DF,EF,FG,GH,GI,HI])
    G1_min_A = Graph("G1_min_A",[A,B,C,D,E,F,G,H,I],[AB,AH,GH,FG,CF,CI,CD,DE])
    G1_min_F = Graph("G1_min_F",[A,B,C,D,E,F,G,H,I],[AB,AH,CD,CF,CI,DE,FG,GH])


    println(@test isequal(prim(G1,A), G1_min_A))
    println(@test isequal(prim(G1,F), G1_min_F))


    # Test 2 -------------------------------------------------------

    println("Exemple plus simple")
    A=Node("a","A",nothing,Inf)
    B=Node("b","B",nothing,Inf)
    C=Node("c","C",nothing,Inf)
    D=Node("d","D",nothing,Inf)
    E=Node("e","E",nothing,Inf)
    F=Node("f","F",nothing,Inf)

    AB=Edge([A,B],1)
    AC=Edge([A,C],2)
    AE=Edge([A,E],10)
    BE=Edge([B,E],3)
    BD=Edge([B,D],4)
    CE=Edge([C,E],8)
    DF=Edge([D,F],5)
    EF=Edge([E,F],6)


    G2 = Graph("G2",[A,B,C,D,E,F],[AB,AC,AE,BE,BD,CE,DF,EF])
    G2_min_A = Graph("G2_min_A",[A,B,C,D,E,F],[AB,AC,BE,BD,DF])


    println(@test isequal(prim(G2,A), G2_min_A))


    # Test 3 -------------------------------------------------------

    println("Exemple avec plusieurs solutions")
    A=Node("a","A",nothing,Inf)
    B=Node("b","B",nothing,Inf)
    C=Node("c","C",nothing,Inf)
    D=Node("d","D",nothing,Inf)
    E=Node("e","E",nothing,Inf)
    F=Node("f","F",nothing,Inf)

    AB=Edge([A,B],3)
    AC=Edge([A,C],7)
    AE=Edge([A,E],3)
    BE=Edge([B,E],1)
    BD=Edge([B,D],2)
    CF=Edge([C,F],5)
    DF=Edge([D,F],6)
    EF=Edge([E,F],8)


    G3 = Graph("G3",[A,B,C,D,E,F],[AB,AC,AE,BE,BD,CF,DF,EF])

    # Prim peut donner deux resultats différents en partant de A ou E
    G3_min_A1 = Graph("G3_min_A1",[A,B,C,D,E,F],[AB,BE,BD,CF,DF])
    G3_min_A2 = Graph("G3_min_A2",[A,B,C,D,E,F],[AE,BE,BD,CF,DF])
    G3_min_E1 = Graph("G3_min_E1",[A,B,C,D,E,F],[AB,BE,BD,CF,DF])
    G3_min_E2 = Graph("G3_min_E2",[A,B,C,D,E,F],[AE,BE,BD,CF,DF])

    println(@test isequal(prim(G3,A), G3_min_A1)||isequal(prim(G3,A), G3_min_A2))
    println(@test isequal(prim(G3,E), G3_min_E1)||isequal(prim(G3,E), G3_min_E2))


    # Test 4 -------------------------------------------------------

    A=Node("a","A",nothing,Inf)
    B=Node("b","B",nothing,Inf)
    C=Node("c","C",nothing,Inf)
    D=Node("d","D",nothing,Inf)
    E=Node("e","E",nothing,Inf)

    AB=Edge([A,B],3)
    AC=Edge([A,C],4)
    AD=Edge([A,D],6)
    AE=Edge([A,E],3)
    BC=Edge([B,C],7)
    BD=Edge([B,D],7)
    BE=Edge([B,E],2)
    CD=Edge([C,D],5)
    CE=Edge([C,E],6)
    DE=Edge([D,E],1)



    G4 = Graph("G4",[A,B,C,D,E],[AB,AC,AD,AE,BC,BD,BE,CD,CE,DE])

    # Prim peut donner deux resultats différents en partant de A
    G4_min_A1 = Graph("G4_min_A1",[A,B,C,D,E],[AB,BE,DE,AC])
    G4_min_A2 = Graph("G4_min_A2",[A,B,C,D,E],[AC,AE,DE,BE])


    println(@test isequal(prim(G4,A), G4_min_A1)||isequal(prim(G4,A), G4_min_A2))
end

# ╔═╡ d30e3890-1c2e-11eb-0c79-850eb41f0fa4
md"# Applications
L'algorithme a été appliqué à l'exemple des notes de cours comme suit :"

# ╔═╡ a68d15e0-1d08-11eb-21c2-d3e036b6328d
with_terminal() do
	open("main.jl","r") do file
	lines=readlines(file)
		for i in 14:42
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
		for i in 10:19
			println(stdout,lines[i])
		end
	end
end

# ╔═╡ d606a620-1c30-11eb-2954-cb052f28d768
md" Cette fonction prend en argument une chaîne de caractère renseignant le nom du fichier sans l'extension .tsp. Par exemple, `test_prim(\"swiss42\")` applique l'algorithme de prim à l'instance `swiss42.tsp`. "

# ╔═╡ Cell order:
# ╟─22431920-1b6d-11eb-1376-177eeadcee26
# ╟─25c2ca00-1b6d-11eb-26d5-35ff69b37966
# ╟─7c957680-1b6c-11eb-3bc0-315c8874ae39
# ╠═d8a78540-1b6b-11eb-2c7d-dd5c13a7815b
# ╟─8996aba0-1c26-11eb-1db3-ebbe71d36a15
# ╠═44d01e80-1b6c-11eb-257c-59e52060b6da
# ╟─4012c810-1b6d-11eb-2359-0177f7165cac
# ╟─a1fb2c6e-1b6d-11eb-3383-59299459c799
# ╟─cae899b0-1d07-11eb-08fd-1fa36280c232
# ╟─b1fec0a0-1b6d-11eb-0b22-3d6f20daa594
# ╟─e51f48b0-1b6d-11eb-0052-07b2534037c6
# ╟─4cc56800-1c27-11eb-28c9-5d368320a436
# ╟─602853d0-1c27-11eb-0797-67ae6fb38e3a
# ╟─fd221d20-1d07-11eb-10cf-6d8504e57e14
# ╟─682ca26e-1c27-11eb-2d16-03e68885f39e
# ╟─d81f70d0-1c2c-11eb-033b-17b0b7f61f3d
# ╟─f336b680-1c2c-11eb-2b34-a5c6949024ac
# ╟─ac2c7480-1c2e-11eb-0d28-379d5b29cbee
# ╠═c9856cd0-1c2e-11eb-3531-733daaa4dd4f
# ╠═6e8388f0-1d08-11eb-1b19-a1b49c840550
# ╟─d30e3890-1c2e-11eb-0c79-850eb41f0fa4
# ╟─a68d15e0-1d08-11eb-21c2-d3e036b6328d
# ╟─2063bca0-1c2f-11eb-1db6-8dc51026b586
# ╟─293b39c0-1c2f-11eb-1b82-7d6da78b2a0e
# ╟─4f671b50-1c2f-11eb-3e8d-77f8e46c333b
# ╟─6aa793e2-1c2f-11eb-1297-fbc895d9dfb4
# ╟─851fe500-1c30-11eb-3686-f751a99e1321
# ╟─aecbeca0-1c30-11eb-248a-41882f2b04bc
# ╟─c2133a20-1c30-11eb-2651-a172fefe4ae0
# ╟─d606a620-1c30-11eb-2954-cb052f28d768
