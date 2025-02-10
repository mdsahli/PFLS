seq=$(grep '>' $1 | wc -l)
length_seq=$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' $1 | grep -v '>' | awk '{print length}' | awk '{ total += $1 } END { print total }')
longest_seq=$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' $1 | grep -v '>' | awk '{print length}' | sort -n | tail -n 1)
shortest_seq=$(awk '/>/ {if (seq) print seq; print; seq=""; next} {seq=seq $0} END {print seq}' $1 | grep -v '>' | awk '{print length}' | sort -n | head -n 1)
average_seq=$((length_seq/seq))

A_count=$(grep -v '>' $1 | grep -o 'A' | wc -l)
T_count=$(grep -v '>' $1 | grep -o 'T' | wc -l)
G_count=$(grep -v '>' $1 | grep -o 'G' | wc -l)
C_count=$(grep -v '>' $1 | grep -o 'C' | wc -l)

GC_count=$((G_count+C_count))
AT_count=$((A_count+T_count))
both=$((GC_count+AT_count))

GC_percent=$(echo "scale=2; $GC_count / $both * 100" | bc -l)

echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $seq"
echo "Total length of sequences: $length_seq"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $average_seq"
echo "GC Content (%): $GC_percent"
