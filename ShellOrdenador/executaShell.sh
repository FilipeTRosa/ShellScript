#!/bin/bash

# Variáveis
linguagem=""
algoritmo=""
num_execucoes=0
tamanho_entrada=0
saida_tempo=""  # Variável para arquivo de saída

# Argumentos
while getopts "l:a:n:t:" opt; do
    case $opt in
        l) linguagem=$OPTARG ;;
        a) algoritmo=$OPTARG ;;
        n) num_execucoes=$OPTARG ;;
        t) tamanho_entrada=$OPTARG ;;
        *) echo "Argumento não suportado" && exit 1 ;;
    esac
done

# Nome do arquivo de saída
saida_tempo="tempos_${linguagem}_${tamanho_entrada}_${algoritmo}.csv"

# Limpar ou criar o arquivo de saída
echo "Tamanho_Entrada,Execucao,Tempo(s)" > $saida_tempo

# Executar o algoritmo em Python
executar_python() {
##### ERRO DE SYNTAX COM TAMANHO DE ENTRADA < 51 ### Não faz sentido
	tempo_totalpy=0
	#echo "$tamanho_entrada" Printa normal o tamanho da entrada
    for ((i = 1; i <= num_execucoes; i++)); do
        #echo "Executando Python $algoritmo - Execução $i..."
        string_tempo=$(python3 "$algoritmo.py" "$tamanho_entrada") # Captura do tempo calculado no py
        tempo=$(echo "$string_tempo" | bc)
        echo "$tamanho_entrada,$i,$tempo" >> $saida_tempo
        tempo_totalpy=$(echo "$tempo_totalpy + $tempo" | bc)
    done
    	#media_py=$(echo "$tempo_totalpy / $num_execucoes" | bc)
    	#echo "$media_py"
    	echo "$tempo_totalpy"
}

# Compilar e executar o algoritmo em C
executar_c() {
##Funciona sem erros... mas nao calcula a media.... Fica zerado#### Provavel erro de tipo de dado
	tempo_totalc=0
    gcc -o "$algoritmo" "$algoritmo.c" || { echo "Erro ao compilar $algoritmo.c"; exit 1; }
    for ((i = 1; i <= num_execucoes; i++)); do
        #echo "Executando C $algoritmo - Execução $i..."
        string_tempo=$(./"$algoritmo" "$tamanho_entrada") # Captura do tempo do codigo C
        tempo=$(echo "$string_tempo" | bc)
        echo "$tamanho_entrada,$i,$tempo" >> $saida_tempo
        tempo_totalc=$(echo "$tempo_totalc + $tempo" | bc)
    done
    	#media_c=$(echo "scale=3; $tempo_totalc / $num_execucoes" | bc) ## Fica zerado mesmo com scale grande
    	#echo "$media_c"
	echo "$tempo_totalc"

}

# Chamada da função
case $linguagem in
    python) executar_python ;;
    c) executar_c ;;
    *) echo "Linguagem não suportada: $linguagem" && exit 1 ;;
esac

#echo "Resultados armazenados em: $saida_tempo"
