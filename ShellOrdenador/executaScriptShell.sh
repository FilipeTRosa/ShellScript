#!/bin/bash

# Função para mostrar como usar o script
usage() {
    echo "Uso: $0 -l linguagem -a algoritmo -n numero_execucoes -t tamanho_entrada"
    exit 1
}

# Variáveis iniciais
linguagem=""
algoritmo=""
num_execucoes=0
tamanho_entrada=0

# Captura dos argumentos
while getopts "l:a:n:t:" opt; do
    case $opt in
        l) linguagem=$OPTARG ;;
        a) algoritmo=$OPTARG ;;
        n) num_execucoes=$OPTARG ;;
        t) tamanho_entrada=$OPTARG ;;
        *) usage ;;
    esac
done

# Verificar se todos os parâmetros foram fornecidos
if [ -z "$linguagem" ] || [ -z "$algoritmo" ] || [ -z "$num_execucoes" ] || [ -z "$tamanho_entrada" ]; then
    usage
fi

# Função para executar o algoritmo em Python
executar_python() {
    for ((i = 1; i <= num_execucoes; i++)); do
        echo "Execução $i: Python $algoritmo com entrada de tamanho $tamanho_entrada"
        python3 "$algoritmo.py" "$tamanho_entrada"
    done
}

# Função para compilar e executar o algoritmo em C
executar_c() {
    gcc -o "$algoritmo" "$algoritmo.c"
    for ((i = 1; i <= num_execucoes; i++)); do
        echo "Execução $i: C $algoritmo com entrada de tamanho $tamanho_entrada"
        ./"$algoritmo" "$tamanho_entrada"
    done
}

# Chamada da função correspondente
case $linguagem in
    python) executar_python ;;
    c) executar_c ;;
    *) echo "Linguagem não suportada: $linguagem" && exit 1 ;;
esac
