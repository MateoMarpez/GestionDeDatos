Ejercicio 1 – PCs, Laptops e Impresoras
a) ¿Qué modelos de PC tienen una velocidad de al menos 150?
	select veloc >= 150 (pc);

b) ¿Qué fabricantes hacen laptops con un disco duro de al menos un gigabyte?
	% Obtenemos los codigos de las laptop que tienen al menos 1GB de HDD%
	unGiga := project cod (select hd >=1 (laptop));

	% Limpiamos la lista de productos dejando solo el codigo y los fabricantes %
	fabricantes := project fabricante, cod (producto);	

	% Listamos los fabricantes de las laptop que tengan al menos 1GB de HDD %
	resultado := project fabricante ((unGiga) njoin (fabricantes));

c) Hallar el número de modelo y el precio de todos los productos (de cualquier tipo) hechos por el fabricante B.
	% Obtenemos una lista de los codigos de todos los productos del fabricante B %
	codigoB := project cod (select fabricante = 'B' (producto));

	% Almacenamos las pc que son del fabricante B %
	listaPc := (codigoB) njoin (project cod, precio (pc));

	% Almacenamos las laptop que son del fabricante B %
	listaLaptop := (codigoB) njoin (project cod, precio (laptop));

	% Almacenamos las impresora que son del fabricante B %
	listaImpresora := (codigoB) njoin (project cod, precio (impresora));

	% Unimos las listas %
	resultado := listaPc union (listaLaptop union listaImpresora);

d) Hallar el número de modelo de todas las impresoras color.
	project cod (select color = 'T' (impresora));

e) Hallar los fabricantes que venden laptops pero no PCs.
	% Hallamos una lista de que vende cada fabricante (exclutendo las impresoras) %
	listaFabricantep := project fabricante, tipo (producto);
	listaFabricante := (listaFabricantep) difference (select tipo = 'Impresora' (listaFabricantep));

	% Hallamos aquellos que no producen Pc %
	noPc := project fabricante ( select tipo = 'Pc' (listaFabricante));

	% Quitamos aquelos vendedores que venden Pc %
	resultado := (project fabricante (listaFabricante)) difference (noPc);

f) Hallar aquellos tamaños de discos que ocurren en dos o más PCs.
	% Creamos dos listas iguales de pc %
	lista1 := project cod, hd (pc);
	lista2 (cod2, hd2) := project cod, hd (lista1); 
	
	% Unimos las listas en una sola %
	lista := lista1 product lista2;

	% Comparamos para saber cuales estan repetidos los tamaños %
	tam := select hd = hd2 (lista); 
	tam2 := tam difference (select cod = cod2 (lista));

	% Limpiamos para solo listar el tamaño %
	resultado := project hd (tam2);

g) Hallar pares de modelos de PC tales que ambos posean la misma velocidad y RAM. Un par debe ser listado una sola vez: (i,j) pero no (j,i)
	% Creamos dos listas iguales de pc %
	lista1 := project cod, veloc, ram (pc);
	lista2 (cod2, veloc2, ram2) := project cod, veloc, ram (lista1); 

	% Unimos las listas en una sola %
	lista := lista1 product lista2;	

	% Comparamos cuales tienen igual velocidad y ram %
	tam := select veloc = veloc2 and ram = ram2 (lista); 

	% Buscamos aquellos que tienen la forma (i,i) y (i,j) %
	tam2 := select cod > cod2 or cod = cod2 (tam);
	resultado := project cod, cod2 (tam difference tam2);

h) Hallar aquellos fabricantes que ofrezcan computadoras (sean PC o laptop) con velocidades de al menos 133.
	% Obtenemos las Pc que tengan al menos 133 de velocidad %
	listaPc := select veloc >= 123 (pc);

	% Obtenemos las laptop que tengan al menos 133 de velocidad %
	listaLaptop := select veloc >= 123 (laptop);

	% Las unimos y solo nos quedamos con sus codigos %
	lista := (project cod (listaPc)) union (project cod (listaLaptop));

	% Obtenemos la lista fabricante-producto %
	fabricantes := project fabricante, cod (producto);

	% Mostramos los fabricantes de los productos de estos codigos %
	resultado := project fabricante ((lista) njoin (fabricantes));

i) Hallar los fabricantes de la computadora (PC o laptop) con la máxima velocidad disponible.
	% Obtenemos dos listas de pc y laptop codigo-velocidad %
	listaCompu := (project veloc, cod (pc)) union (project veloc, cod (laptop));
	listaCompu2(veloc2, cod2) := project veloc, cod (listaCompu); 

	% Obtemeos todos los valores q no son el maximo de velocidad %
	lista := (listaCompu) product (listaCompu2);	
	listaMin := project veloc, cod (select veloc < veloc2 (lista));

	% Obtenemos las velocidades maximas %
	pcMax := (listaCompu) difference (listaMin);

	% Obtenemos los fabricantes de estos productos %
	resultado := project fabricante ((project fabricante, cod (producto)) njoin (pcMax));