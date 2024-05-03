

def calcular3x1(aux, secuencia):

    #secuencia.append(aux)
    secuencia_tamanho = 0
    valor_max = -1


    while aux != -1:

        secuencia.append(aux)
        secuencia_tamanho += 1

        if valor_max < aux:
            valor_max = aux

        if aux == 1:
            break
        else:
            if aux%2==0:
                aux=aux/2
            else:
                aux = aux * 3
                aux = aux + 1     
    
    return secuencia_tamanho, valor_max




def estadisticas(vIni, secuencia, secuencia_tamanho, v_max):
   
    lista=[]

    vT=len(secuencia)

    suma = 0
    for i in secuencia:
        suma = suma + i

    vMed = suma / len(secuencia)


    # We add statisticas to the list 
    lista.append(vIni*vT)
    lista.append(v_max*vT)
    lista.append(vMed * vT)
    lista.append((vIni/v_max)*vT)
    lista.append((vIni/vMed)*vT)
    lista.append((v_max/vIni)*vT)
    lista.append((v_max/vMed)*vT)
    lista.append((vMed/vIni)*vT)
    lista.append((vMed/v_max)*vT)


    #we print the statistics list
    print("Valores lista de estadísticas")
    for i in lista:
        print(i)

    print("\n")
    print("Valor secuencia Máximo:"+str(valor_max))
    print("\n")
    print("Valor secuencia Media: "+str(vMed))
    print("\n")
    print("Valor secuencua tamaño: "+str(secuencia_tamanho))
    print("\n")
    print("Valores secuencia:")
    for i in secuencia:
        print(i)




if __name__ == "__main__":
    
    vIni = 10
    
    secuencia=[]
    
    secuencia_tamanho, valor_max = calcular3x1(vIni, secuencia)
    
    print("Imprimirmos estadisticas del programa")
    estadisticas(vIni, secuencia, secuencia_tamanho, valor_max)