Ejercicio 2 – Barcos
a) Los nombres y los países de las clases que llevaban cañones de al menos 16 pulgadas de calibre.
  % Obtemos las clases que tengan al menos 16 pulgadas de calibre %
  resultado := project clase, pais (select calibre >= 16 (clase));

b) Hallar los barcos botados antes de 1921.
  % Obtenemos los barcos donde botado sea menor que 1921 %
  resultado := project nombre (select botado < 1921 (barco));

c) Hallar los barcos hundidos en la batalla del Atlántico Norte.
  % Obtemos el nombre de los barcos que participaron en dicha batalla y se hayan hundidos %
  resultado := select ((batalla = 'Atlántico Norte') and (resultado = 'Hundido')) (participa);

d) El tratado de Washington de 1921 prohibió los barcos de más de 35000 toneladas. Listar los barcos que violaron el tratado de Washington.
  % Obtenemos todos los barcos botados despues del 1921 %
  barcosTratado := project nombre, clase (select botado > 1921 (barco));

  % Nos fijamos cuales pesan mas de 35000 toneladas %
  claseTratado := (barcosTratado) njoin (project clase, desplazamiento (clase));
  resultado := project nombre (select desplazamiento > 35000 (claseTratado));

e) Listar el nombre, el desplazamiento y el número de cañones de los barcos que participaron de la batalla de Guadalcanal.
  % Obtenemos los barcos que participaron en la batalla de Guadalcanal %
  listaBarcos := project barco (select batalla = 'Guadalcanal' (participa));

  % Cambiamos el campo barco por nombre %
  listaNombre(nombre) := project barco (listaBarcos);

  % Obtenemos la lista de las clases de los barcos &
  listaClase := project nombre, clase ((listaNombre) njoin (barco));

  % Obtememos la lista de los datos que se piden %
  resultado := project nombre, desplazamiento, caniones ((listaClase) njoin (clase));

f) Hallar los países que tuvieron tanto cruceros como acorazados.

g) Hallar los barcos que, siendo dañados en alguna batalla, participaron posteriormente de alguna otra.
  % Unimos la tabla batalla con participa, para saber cuando fue la batalla %
  listaBatalla(batalla, fecha) := project nombre, fecha (batalla);
  listaBarcos := ((listaBatalla) njoin (participa));

  % Hacemos un producto, dejando solamente aquellos que el producto se hacen con el mismo barco %
  listaBarcos2(batalla2, fecha2, barco2, resultado2) := project batalla, fecha, barco, resultado (listaBarcos);

  % Nos fijamos que barcos participaron en mas de 1 batalla, eliminando los duplicados y las los pares que son diferentes barcos %
  listaParti := (listaBarcos) product (listaBarcos2);
  listaParti2 := select (batalla = batalla2 and fecha = fecha2 and barco = barco2) or (barco <> barco2) (listaParti);
  unaBatalla := (listaParti) difference (listaParti2);

  % Nos fijamos cuales fueron dañados y participaron en una segunda guerra %
  resultado := project barco (select fecha > fecha2 and resultado = 'Dañado' (unaBatalla));

h) ¿La base de datos presentada como ejemplo se encuentra en estado consistente? De no ser así, indique alguna inconsistencia que haya encontrado, y la expresión del álgebra relacionar que le permitió hallarla.
  
