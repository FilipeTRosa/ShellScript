#!/bin/bash

# Verificar se o script principal foi passado como parâmetro
if [ -z "$1" ]; then
    echo "Uso: $0 <caminho_para_script_principal>"
    exit 1
fi

script_principal=$1 # Caminho para o script principal



# Parâmetros para execução
linguagens=("python" "c")         # Linguagens para testar
algoritmos=("mergesort" "bubblesort") # Algoritmos disponíveis
tamanhos=(10 100 1000 10000 100000)       # Tamanhos deS entrada
num_execucoes=10                 # Número de execuções por tamanho

arquivo_saida="medias_execucoes_${num_execucoes}.csv" # Arquivo de saída consolidado
# Limpar ou criar o arquivo de saída
echo "Linguagem;Algoritmo;Tamanho_Entrada;TempoTotal(s)" > $arquivo_saida

# Iterar sobre linguagens, algoritmos e tamanhos
for linguagem in "${linguagens[@]}"; do
    for algoritmo in "${algoritmos[@]}"; do
        arquivo_saida2="medias_execucoes_${linguagem}_${algoritmo}_${num_execucoes}.csv" # Arquivo de saída consolidado
    	# Cria o arquivo e escreve o cabeçalho apenas uma vez
        if [[ ! -f "$arquivo_saida2" ]]; then
            echo "Linguagem;Algoritmo;Tamanho_Entrada;TempoTotal(s)" > "$arquivo_saida2"
        fi
    	
        for tamanho in "${tamanhos[@]}"; do
            echo "Executando $algoritmo em $linguagem para tamanho $tamanho ($num_execucoes execuções)..."

            # Capturar o tempo retornado pelo script principal
            tempo=$(bash "$script_principal" -l "$linguagem" -a "$algoritmo" -n "$num_execucoes" -t "$tamanho")
            
            #media=$(echo "$tempo / $num_execucoes" | bc) ## FICA ZERADO.....
			
            # Salvar a média no arquivo consolidado
            echo "$linguagem;$algoritmo;$tamanho;$tempo" >> $arquivo_saida
            echo "$linguagem;$algoritmo;$tamanho;$tempo" >> $arquivo_saida2
        done
    done
done

echo "Resultados consolidados armazenados em: $arquivo_saida"

