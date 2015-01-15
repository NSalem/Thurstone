---
title: "Escalamiento de Thurstone en R"
author: 'Trabajo realizado por: Nahuel Antonio Salem García'
output: word_document
job: 'Dirigdo por: Teresa Rivas Moya'
---
<style>
em {
  font-style: italic
}
</style>
<style>
strong {
  font-weight: bold;
}
</style>

## Introducción
El escalamiento de Thurstone (1927): 

> * Ordena estímulos en un continuo psicológico

> * Utiliza el método de comparaciones de pares de estímulos

---

## Introducción

Cada estímulo se compara con cada uno de los demás por pares. En cada par el sujeto indica cuál es superior en un atributo específico, por ejemplo preferencia. 

Dados `n` estÃ?mulos hay `n(n-1)/2` comparaciones posibles. 

El resultado es una tabla de frecuencias absolutas. El número en cada casilla es la cantidad de personas que eligieron el estímulo de la columna sobre el de la fila. Si se divide por el número de personas se obtienen las frecuencias relativas (entre 0 y 1).

__Caso V__: distancia entre estímulos co la puntuación típica de la distribución normal asociada a la proporción de veces que un estímulo es preferido a otro

---

## Introducción
Ejemplo de tabla de frecuencias relativas. Preferencias para distintas verduras (Guilford, 1954).


```
##          Turn   Cab  Beet   Asp   Car  Spin S.Beans  Peas  Corn
## Turn    0.500 0.818 0.770 0.811 0.878 0.892   0.899 0.892 0.926
## Cab     0.182 0.500 0.601 0.723 0.743 0.736   0.811 0.845 0.858
## Beet    0.230 0.399 0.500 0.561 0.736 0.676   0.845 0.797 0.818
## Asp     0.189 0.277 0.439 0.500 0.561 0.588   0.676 0.601 0.730
## Car     0.122 0.257 0.264 0.439 0.500 0.493   0.574 0.709 0.764
## Spin    0.108 0.264 0.324 0.412 0.507 0.500   0.628 0.682 0.628
## S.Beans 0.101 0.189 0.155 0.324 0.426 0.372   0.500 0.527 0.642
## Peas    0.108 0.155 0.203 0.399 0.291 0.318   0.473 0.500 0.628
## Corn    0.074 0.142 0.182 0.270 0.236 0.372   0.358 0.372 0.500
```

---

## Introducción

asd  <http://nsalem.github.io/tipcs/>

El paquete __psych__ de R contiene la función `thurstone`. Esta función permite hallar valores de escala en base a comparaciones mútiples entre estímulos. Pero:

> * No funciona con __datos incompletos__
> * No devuelve la __discrepancia media__ (sí otra medida de bondad de ajuste)

---

## Introducción

En este trabajo se explora cómo hallar con R:

> * Los __valores de escala__ para datos completos e incompletos
> * La __discrepancia media__

---

## Método 

Los datos que se utilizan para los ejemplos son:

- Comparaciones por pares de 9 verduras (Guilford, 1954). Disponibles en el paquete `psych`como `veg`. 

- Comparaciones por pares de preferencias entre 5 universidades (Ghiselli et al., 1981). 100 participantes. 

En ambos casos, cada casilla de la tabla representa la proporción de participantes que eligieron como preferida la opción de la fila a la de la columna.

---

## Método
Frecuencias relativas de preferencias de verduras

```r
library (psych)
veg
```

```
##          Turn   Cab  Beet   Asp   Car  Spin S.Beans  Peas  Corn
## Turn    0.500 0.818 0.770 0.811 0.878 0.892   0.899 0.892 0.926
## Cab     0.182 0.500 0.601 0.723 0.743 0.736   0.811 0.845 0.858
## Beet    0.230 0.399 0.500 0.561 0.736 0.676   0.845 0.797 0.818
## Asp     0.189 0.277 0.439 0.500 0.561 0.588   0.676 0.601 0.730
## Car     0.122 0.257 0.264 0.439 0.500 0.493   0.574 0.709 0.764
## Spin    0.108 0.264 0.324 0.412 0.507 0.500   0.628 0.682 0.628
## S.Beans 0.101 0.189 0.155 0.324 0.426 0.372   0.500 0.527 0.642
## Peas    0.108 0.155 0.203 0.399 0.291 0.318   0.473 0.500 0.628
## Corn    0.074 0.142 0.182 0.270 0.236 0.372   0.358 0.372 0.500
```

---

Frecuencias relativas de preferencias de universidades

```r
A = c(0.50, 0.79, 0.16, 0.48, 0.67)
B = c(0.21, 0.50, 0.03, 0.21, 0.25)
C = c(0.84, 0.97, 0.50, 0.76, 0.81) 
D = c(0.52, 0.79, 0.24, 0.50, 0.68) 
E = c(0.33, 0.75, 0.19, 0.32, 0.50)

uni = data.frame(rbind(A,B,C,D,E))
names(uni) = c("A","B","C","D","E")
uni
```

```
##      A    B    C    D    E
## A 0.50 0.79 0.16 0.48 0.67
## B 0.21 0.50 0.03 0.21 0.25
## C 0.84 0.97 0.50 0.76 0.81
## D 0.52 0.79 0.24 0.50 0.68
## E 0.33 0.75 0.19 0.32 0.50
```

---

## Método

En este trabajo los datos han sido analizados con R, utilizando el paquete `psych` y una función propia creada para el caso.

---

## Método 

Veamos cómo funciona la función `thurstone` en los datos de preferencia de verduras:


```r
library("psych")
thurstone(veg)
```

```
## Thurstonian scale (case 5) scale values 
## Call: thurstone(x = veg)
##    Turn     Cab    Beet     Asp     Car    Spin S.Beans    Peas    Corn 
##    0.00    0.52    0.65    0.98    1.12    1.14    1.40    1.44    1.63 
## 
##  Goodness of fit of model   0.99
```

Los valores de escala indican que el **maíz** (Corn) seria la verdura más preferida de las 9, mientras que el **nabo** (Turn) sería la menos preferida.
La medida de bondad de bondad de ajuste (Goodness of fit of model) que utiliza esta función puede estar entre 0 y 1, siendo mejor cuando más cerca esté de 1. 

---

## Método

Para la discrepancia media se ha definido la función `thurstone_dm` en un script de R. A continuación se muestra cómo funciona:


```r
source("thurstone.R")
thurstone_dm(veg)
```

```
## $val_escala
##      Turn       Cab      Beet       Asp       Car      Spin   S.Beans 
## 0.0000000 0.5220458 0.6544394 0.9795439 1.1170831 1.1437223 1.4001155 
##      Peas      Corn 
## 1.4438341 1.6294420 
## 
## $DM
## [1] 0.03508756
```

---

## Método

Ahora veamos cómo funciona la función `thurstone` en datos incompletos:

```r
veg2 = veg
veg2[2,][,1] = NA
veg2[1,][,2] = NA
thurstone(veg2)
```

```
## Thurstonian scale (case 5) scale values 
## Call: thurstone(x = veg2)
##    Turn     Cab    Beet     Asp     Car    Spin S.Beans    Peas    Corn 
##      NA      NA      NA      NA      NA      NA      NA      NA      NA 
## 
##  Goodness of fit of model   NA
```

La función no puede hallar los valores de escala.

---

## Método

Para hallar los valores de escala para datos incompletos se ha definido la función `thurstone_incompletos`. Así, al usarla con los datos mostrados antes se consiguen los valores de escala


```r
veg2 = veg
veg2[2,][,1] = NA #convertir el valor de la segunda fila y primera columna de veg2 en NA
veg2[1,][,2] = NA #convertir el valor de la primera fila y segunda columna de veg2 en NA
thurstone_incompletos(veg2)
```

```
##         Turn      Cab      Beet       Asp      Car    Spin  S.Beans
## Valores    0 0.411839 0.5818972 0.9070017 1.044541 1.07118 1.327573
##             Peas   Corn
## Valores 1.371292 1.5569
```

---

## Método

La función `thurstone_incompletos` también sirve para datos con valores fuera de un intervalo establecido. Así, se puede escribir `thurstone_incompletos(datos, umbral1, umbral2)`, donde `datos`es el conjunto de datos del que queremos obtener los valores de escala y `umbral1` y `umbral2` son valores entre 0 y 1. Los valores de la tabla fuera del intervalo (umbral1, umbral2) serán omitidos.

Ejemplo: Hallar valores de escala omitiendo proporciones menores que 0.01 y mayores que 0.99

```r
veg3 = veg
veg3[2,][,1] = 0.99 #convertir el valor de la segunda fila y primera columna de veg3 en 0.99
veg3[1,][,2] = 0.01 #convertir el valor de la primera fila y segunda columna de veg3 en 0.01
thurstone_incompletos(veg3, 0.01, 0.99) #hallar valores de escala con umbrales 0.01 y 0.99
```

```
##             Turn Cab    Beet       Asp       Car      Spin  S.Beans
## Valores 0.196647   0 0.49174 0.8168445 0.9543837 0.9810228 1.237416
##             Peas     Corn
## Valores 1.281135 1.466743
```

---

## Método

Otro ejemplo con los datos de Edwards (1957):


```r
d2
```

```
##     [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8] [,9]
## i1 0.500 0.923 0.923 0.949 0.987 0.987 1.000 0.949 1.00
## i2 0.077 0.500 0.526 0.731 0.872 0.987 0.949 0.846 0.96
## i3 0.077 0.474 0.500 0.615 0.910 0.923 0.936 0.872 0.96
## i4 0.051 0.269 0.385 0.500 0.859 0.897 0.910 0.833 0.93
## i5 0.013 0.128 0.090 0.141 0.500 0.769 0.782 0.756 0.85
## i6 0.013 0.013 0.077 0.103 0.231 0.500 0.564 0.705 0.83
## i7 0.000 0.051 0.064 0.090 0.218 0.436 0.500 0.654 0.66
## i8 0.051 0.154 0.128 0.167 0.244 0.295 0.346 0.500 0.39
## i9 0.000 0.038 0.038 0.064 0.141 0.167 0.333 0.602 0.50
```

---


```r
thurstone_incompletos(d2)
```

```
##         [,1]     [,2]     [,3]     [,4]    [,5]    [,6]     [,7]     [,8]
## Valores    0 1.169323 1.200044 1.463857 2.15508 2.53036 2.703987 2.753748
##            [,9]
## Valores 3.01531
```

---


## Conclusiones



## Referencias

Edwards, A. L. Techniques of attitude scale construction. New York: Appleton-Century- Crofts, 1957.

Thurstone, L. L. (1927) A law of comparative judgments. Psychological Review, 34, 273-286.

A general guide to personality theory and research may be found at the personality-project http://personality-project.org. See also the short guide to R at http://personality-project.org/r. In addition, see

Revelle, W. (in preparation) An Introduction to Psychometric Theory with applications in R. Springer. at http://personality-project.org/r/book/

Guilford, J.P. (1954) Psychometric Methods. McGraw-Hill, New York.

Ghiselli, E.E., Campbell, J.P. & Zedeck, S. (1981). Measurement
theory for the behavioral sciences. San Francisco, Callifornia:
Freeman & Company
