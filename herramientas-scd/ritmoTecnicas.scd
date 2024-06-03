


//////    Ritmo
// Sistemas L para ritmo
/*un sistema de reescritura paralelo y un tipo de gramática formal. Un sistema L consta de un alfabeto de símbolos que se pueden usar para formar cadenas, una colección de reglas de producción que expanden cada símbolo en una cadena más grande de símbolos, una cadena "axioma" inicial a partir de la cual comenzar la construcción y un mecanismo para traducir las cadenas generadas en estructuras geométricas.*/

/*El sistema L original de Lindenmayer para modelar el crecimiento de algas.

variables  : AB
constantes  : ninguna
axioma  : A
reglas  : (A → AB), (B → A)
que produce:

norte = 0 : Un
norte = 1 : AB
norte = 2 : ABA
n = 3 : ABAAB
n = 4 : ABABABA
n = 5 : ABABABAABAAB
n = 6 : ABABABAABAABABAABABA
n = 7 : ABABABAABAABABAABABAABAABABAABAAB
Ejemplo 1: algas, explicadas
n=0: Un comienzo (axioma/iniciador)
                  /\
n=1: AB, el único A inicial generado en AB por la regla (A → AB), la regla (B → A) no se pudo aplicar
                /| \
n=2: ABA antigua cadena AB con todas las reglas aplicadas, A generó nuevamente AB, la antigua B se convirtió en A
             / | | | \
n=3: ABAAB nota que todos los A producen una copia de sí mismos en primer lugar, luego un B, que se convierte...
           / | | | \ | \ \
n=4: ABAABABA... en una A una generación más tarde, comenzando a generar/repetir/recurrir luego
El resultado es la secuencia de palabras de Fibonacci . Si contamos la longitud de cada cuerda, obtenemos la famosa secuencia de números de Fibonacci (omitándonos el primer 1, debido a nuestra elección del axioma):

1 2 3 5 8 13 21 34 55 89 ...
Si no queremos omitir el primero, podemos usar el axioma B. Eso colocaría el nodo B antes del nodo superior ( A ) del gráfico anterior.

Para cada cadena, si contamos la k -ésima posición desde el extremo izquierdo de la cadena, el valor se determina en función de si un múltiplo de la proporción áurea cae dentro del intervalo
*/
//L-systems basic example
//use L-system as a duration value for a kickdrum
(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
            0.25: [3,3,2]/4,
        3/4: [0.25,1,0.125,0.125],
        ), 4);
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,l,\amp,1);
~k.pause;

)
/*

With that grammar:

1 -> 0.25,2 -> 3/4,3/4,2/4 -> 0.25,1,0.125,0.125,0.25,1,0.125,0.125 -> etc.

*/
//much like with the euclidean rhythm convergence/divergence pattern, you can use variable l for different patterns too
(
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,l,\amp,1,\rate,Pseq((1..4)/2,inf));
~sn.play;
)
//and transform it
(
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,l,\stretch,Pwhite(0.5,2).round(0.5),\amp,Pwhite(0.2,1));
~h.play;
)
//an off-beat open hat for reference
(
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,1);
~oh.play;
)

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
//////////////////////////// RITMOS EUCLEDIANOS //////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////





/* 'El algoritmo euclidiano genera ritmos musicales tradicionales' , que describe la organización del ritmo colocando inicios lo más uniformemente posible dentro de una serie de espacios posibles utilizando el algoritmo de Bjorklund.*/

/* El quark Bjorklund y Bjorklund2 contiene algunas clases que ayudan a utilizar los ritmos euclidianos
*/

//four 'randomised' rhythms, sounds okay.

(
p.clock.tempo = 2.2;
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,Pwhite(0.25,1).round(0.25),\amp,1);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][1],\dur,Pwhite(0.25,1).round(0.25),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][1],\dur,Pwhite(0.25,1).round(0.25),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pwhite(0.25,1).round(0.25),\amp,1);
~k.play;
~sn.play;
~h.play;
~t.play;
)

//four randomised euclidean rhythms with four different samples.
//sounds better, producing a much greater variety of rhythmic forms.
(
p.clock.tempo = 2.2;
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~k.play;
~sn.play;
~h.play;
~t.play;
)






