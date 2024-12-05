#!/bin/bash

# Nome do arquivo CSV
ARQUIVO="medias_execucoes_10.csv"

# Nome do gráfico de saída
SAIDA="grafico_comparacao.png"

# Verifica se o arquivo CSV existe
if [[ ! -f "$ARQUIVO" ]]; then
    echo "Erro: Arquivo '$ARQUIVO' não encontrado."
    exit 1
fi

# Gera o script GNUplot dinamicamente
cat << EOF > script_gnuplot.gp
set datafile separator ";"
set terminal png size 800,600
set output "$SAIDA"

set title "Comparação de Algoritmos e Linguagens"
set xlabel "Tamanho de Entrada"
set ylabel "Tempo Total (s)"
set logscale y
set key outside
set grid

set style data linespoints

plot \\
    "$ARQUIVO" using 3:4 title "Python - MergeSort" with linespoints lc rgb "red", \
    "$ARQUIVO" using 3:4 every ::4::6 title "Python - BubbleSort" with linespoints lc rgb "blue", \
    "$ARQUIVO" using 3:4 every ::7::9 title "C - MergeSort" with linespoints lc rgb "green", \
    "$ARQUIVO" using 3:4 every ::10::12 title "C - BubbleSort" with linespoints lc rgb "purple"
EOF

# Executa o GNUplot
gnuplot script_gnuplot.gp

# Verifica se o gráfico foi gerado corretamente
if [[ -f "$SAIDA" && -s "$SAIDA" ]]; then
    echo "Gráfico gerado com sucesso: $SAIDA"
else
    echo "Erro: O gráfico não foi gerado corretamente."
fi

# Limpa o script temporário
rm script_gnuplot.gp

