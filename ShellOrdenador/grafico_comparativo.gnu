set terminal png size 800,600
set output 'grafico_comparativo.png'
set title "Comparação de Tempos: Mergesort em Python vs C"
set xlabel "Execuções"
set ylabel "Tempo (s)"
set grid
set key outside

plot \
    "tempos_c_1_bubblesort.dat" using 2:3 with linespoints title "C 1 Bubble", \
    "tempos_c_10_bubblesort.dat" using 2:3 with linespoints title "C 10 Bubble"
