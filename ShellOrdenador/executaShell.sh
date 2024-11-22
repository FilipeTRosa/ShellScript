#!/bin/bash

# Variáveis
linguagem=""
algoritmo=""
num_execucoes=0
tamanho_entrada=0
saida_tempo=""  # Variavel para arquivo de saída

#argumentos
while getopts "l:a:n:t:" opt; do
    case $opt in
        l) linguagem=$OPTARG ;;
        a) algoritmo=$OPTARG ;;
        n) num_execucoes=$OPTARG ;;
        t) tamanho_entrada=$OPTARG ;;
        *) echo "Argumento não suportado" && exit 1;;
    esac
done

# Nome do arquivo de saída
saida_tempo="tempos_${linguagem}_${tamanho_entrada}_${algoritmo}.dat"

# Limpar ou criar o arquivo de saída
echo "Tamanho_Entrada Execucao Tempo(s)" > $saida_tempo

#executar o algoritmo em Python
executar_python() {
    for ((i = 1; i <= num_execucoes; i++)); do
        echo "Executando Python $algoritmo - Execução $i..."
        tempo=$(python3 "$algoritmo.py" "$tamanho_entrada") # Captura do tempo
        echo "$i $tempo" >> $saida_tempo
    done
}

#compilar e executar o algoritmo em C
executar_c() {
    gcc -o "$algoritmo" "$algoritmo.c" || { echo "Erro ao compilar $algoritmo.c"; exit 1; }
    for ((i = 1; i <= num_execucoes; i++)); do
        echo "Executando C $algoritmo - Execução $i..."
        tempo=$(./"$algoritmo" "$tamanho_entrada") # Captura do tempo
        echo "$tamanho_entrada $i $tempo" >> $saida_tempo
    done
}

# Chamada da função
case $linguagem in
    python) executar_python ;;
    c) executar_c ;;
    *) echo "Linguagem não suportada: $linguagem" && exit 1 ;;
esac

echo "Resultados armazenados em: $saida_tempo"
