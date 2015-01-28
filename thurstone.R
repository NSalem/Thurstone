thurstone_dm <- function (matriz, mostrar_todo = FALSE){
#Toma una matriz o dataframe de las frecuencias relativas o absolutas de preferencias en 
#comparaciones por pares. Devuelve los valores de escala de Thurstone y la discrepancia media.

    matriz = data.matrix(matriz) #datos brutos
    n = matriz[1][1]*2 #si las frecuencias dadas son absolutas, el número de participantes es
    #la primera celda multipilcada por dos
    p_observadas <- matriz/n  #frecuencias relativas observadas
    
    z_observadas <- apply(p_observadas, c(1,2), qnorm) #puntuaciones z correspondientes a las frecuencias
    
    incomplete = FALSE
    
    if (sum(is.na(p_observadas)) > 0){incomplete = TRUE} 
    #Si hay algún NA, los datos estan incompletos
    
    if (incomplete == FALSE){   
        #Si los datos no están incompletos:
        medias_z_observadas = apply(z_observadas, 2, mean, na.rm = TRUE)
        #realizar la media de las puntuaciones z observadas de cada columna(ítem)
        
        centered_means = medias_z_observadas-min(medias_z_observadas)
        #Centrar en 0 restando el mínimo a todas las medias.
        
        valores_escala = centered_means
        #Los valores de escala son las medias centradas.
        
        if (any(p_observadas < 0.01| (any(p_observadas > 0.99)))) 
            #Avisar de valores menores que 0.01 o mayores que 0.99
            warning("Hay proporciones fuera del intervalo (0.01, 0.99). Considerar usar procedimiento para datos incompletos")
    }
    
    if (incomplete == TRUE){
        #Avisar de valores perdidos (NAs) si los hay
        warning("Hay valores perdidos (NA). Utilizar procedimiento para datos incompletos")
        break 
    }
    
    
    z_teoricas = data.frame() #dataframe vacío al que se añadirán filas 
                              #para las proporciones tipificadas teóricas
                              # de cada ítem
    
    for (i in 1:length(valores_escala)){
        #Iteración para cada valor de escala.
        # Puntuaciones z'ij en la distribución normal correspondiente
        #a las distancias entre pares de valores de la escala obtenida
        # para los ítems
        row = valores_escala-valores_escala[i] #fila con los valores de escala 
                                               #restando a todos uno de ellos
        z_teoricas = rbind(z_teoricas, row) #añadir fila a z_teoricas
    }
    colnames(z_teoricas) = colnames(matriz) #poner nombres a columnas
    rownames(z_teoricas) = rownames(matriz) #poner nombres a filas
    
    p_teoricas = data.frame(apply(z_teoricas, c(1,2), pnorm)) #Frecuencias teóricas.
    #Se obtiene la proporción a partir de las puntuaciones tipificadas de toda la 
    #tabla z_teoricas).
    
    diferencias <- p_observadas - p_teoricas #diferencia entre frecuencias observadas y teóricas
    
    suma_diferencias = c() # vector vacío
    
    for (i in 1:ncol(diferencias)){
        #Para todas las columnas de la matriz de las diferencias sumar 
        #cada columna por debajo de la diagonal.

        sum_dif = sum(abs(diferencias[i][(i+1):nrow(diferencias),]))
        #suma los valores absolutos de las celdas de una columna i acotando 
        #los valores que van desde la fila i+1 hasta la última. 
        #Por ejemplo, cuando i es 3, se suman los valores de la columna 3
        #desde la fila 4 hasta la última, evitando las celdas que quedan por encima. 
        
        suma_diferencias = c(suma_diferencias, sum_dif) #añadir valor
        
    }
    
    dm = sum(suma_diferencias, na.rm = TRUE)/(nrow(diferencias)*(nrow(diferencias)-1)/2) #Discrepancia media
    #calcular discrepancia media. suma de las sumas de las diferencias 
    #dividida entre (n(n-1)/2),siendo n el número de ítems (filas).
    
    if (mostrar_todo == TRUE){
    #Si se ha especificado mostrar_todo = TRUE, devolver lista con todos los pasos 
    #intermedios.
    return (list("Proporciones observadas" = p_observadas, "z observadas" = z_observadas, 
                "Medias" = medias_z_observadas, "Valores de escala" = valores_escala, 
                "z teóricas" = z_teoricas, "Frecuencias teóricas" = p_teoricas,
                "diferencias" = diferencias,"Suma de diferencias" = suma_diferencias, DM = dm))
    }
    
    else{
    #Si no se ha especificado, devolver los valores de escala y la discrepancia media. 
        return(list("Valores de escala" = valores_escala, "DM" = dm))
    }
        
}
thurstone_incompletos = function(matriz, mostrar_todo = FALSE, umbral1 = NA, umbral2 = NA){
    #Toma una matriz o dataframe de las frecuencias relativas o absolutas
    #Devuelve los valores de escala de Thurstone utilizando el procedimiento para datos 
    #incompletos
    #Se considerarán valores perdidos aquellos que estén fuera del intervalo (umbral1, umbral2)
    #Si no se especifican valores para umbral1 y umbral2, se establecerán automáticamente como 
    #(0.01, 0.99) si hay 200 o más comparaciones o (0.02, 0.98) si hay menos de 200 comparaciones
    
    matriz = data.matrix(matriz) #datos brutos
    n = matriz[1][1]*2 #número de participantes
    juicios = (nrow(matriz)*(nrow(matriz)-1)/2)
    p_observadas <- matriz/n  #frecuencias relativas observadas
    
    if (is.na(umbral1)&is.na(umbral2)){ 
        #establece umbrales automáticamente si no se han especificado
        if (juicios >= 200){umbral1 = 0.01; umbral2 = 0.99}      
        else {umbral1 = 0.02; umbral2 = 0.98} 
        
    }
    
    for (i in 1:length(p_observadas)){ 
        #Converitr en NAs los valores fuera del intervalo establecido 
        if (is.na(p_observadas[i]) | p_observadas[i]<umbral1 | p_observadas[i]>umbral2){
            p_observadas[i] = NA 
        }
    }
    
    z_observadas <- apply(p_observadas, c(1,2), qnorm) 
    #puntuaciones z correspondientes a las frecuencias
    
    diferencias_sucesivas = c() #vector vacío
    
    for (col in 2:ncol(z_observadas)){ 
        # crear matriz de diferencias entre columnas de z_observadas
        column = z_observadas[,col] - z_observadas[,(col-1)] 
        diferencias_sucesivas = cbind(diferencias_sucesivas, column)
    }
    
    medias = apply(diferencias_sucesivas, 2, mean, na.rm = TRUE) #medias de las columnas
    medias = append(medias, 0, 0) #añadir 0 al principio
    
    v_escala = 0 #valor de escala del primer elemento. Establecer 0 como origen.
    
    for (i in 2:length(medias)){ 
        #obtener valores de escala uno por uno, sumando a cada media el valor de escala anterior
        s = medias[i]+v_escala[(i-1)]
        v_escala = cbind(v_escala, s)
    }
    colnames(v_escala) = colnames(matrix) #cambiar nombres de las columnas
    rownames(v_escala) = "Valores" #cambiar nombre de fila
    
    v_escala = v_escala - min(v_escala) #Poner el mínimo en 0.
    
    if (mostrar_todo == TRUE){
        #si se ha especificado mostrar_todo = TRUE en la función, devolver lista con valores de 
        #escapa y pasos intermedios
    return(list("p observadas" = p_observadas, "z observadas" = z_observadas, 
               "Diferencias sucesivas" = diferencias_sucesivas, "Valores de escala" = v_escala))
    }
    else{
        #Si no se ha especificado mostrar_todo = TRUE en la función, devolver sólo los valores de
        #escala
        return(list("Valores de escala" = v_escala))
    }
}