if [  -d ./COMBINED-DATA ]
    then
        rm -rf COMBINED-DATA
        mkdir COMBINED-DATA

    else mkdir COMBINED-DATA
fi

        for direct in ./RAW-DATA/*/
                  do 
MAG_COUNT=1
BIN_COUNT=1

        for fastas in "$direct"bins/*.fasta
            do 
                      XXX=$(grep "$(basename "$direct" /)" './RAW-DATA/sample-translation.txt' | awk '{print $2}')

        if [[ "$fastas" != "${direct}bins/bin-unbinned.fasta" ]] 
            then
                
                      completion=$(grep "$(basename "$fastas" .fasta)" "${direct}/checkm.txt" |  awk '{print $13}')
                      contamination=$(grep "$(basename "$fastas" .fasta)" "${direct}/checkm.txt" |  awk '{print $14}')

        if (( $(echo "$completion >= 50.00" | bc -l)  &&  $(echo "$contamination <= 5.00" | bc -l) ))
            then
                        YYY="MAG"
                        ZZZ=$(printf "%03d" $MAG_COUNT) 
                        ((MAG_COUNT++))  
            else
                        YYY="BIN"
                        ZZZ=$(printf "%03d" $BIN_COUNT)
                        ((BIN_COUNT++))  

         fi

            echo "${XXX}_${YYY}_${ZZZ}.fa"
            cp "$fastas" "./COMBINED-DATA/${XXX}_${YYY}_${ZZZ}.fa"

        fi

         if [[ "$fastas" == "${direct}bins/bin-unbinned.fasta" ]]
            then
            echo "${XXX}_UNBINNED.fa"

            cp "$fastas" "./COMBINED-DATA/${XXX}_UNBINNED.fa"

        fi

        done
  
for checkm in "$direct"checkm.txt
        do
                    XXX=$(grep "$(basename "$direct" /)" './RAW-DATA/sample-translation.txt' | awk '{print $2}')

        echo "$XXX-CHECKM.txt"

        cp "$checkm" "./COMBINED-DATA/${XXX}-CHECKM.txt"
done

for gtdb in "$direct"gtdb.gtdbtk.tax
        do
                    XXX=$(grep "$(basename "$direct" /)" './RAW-DATA/sample-translation.txt' | awk '{print $2}')

        echo "$XXX-GTDB-TAX.txt"

        cp "$gtdb" "./COMBINED-DATA/${XXX}-GTDB-TAX.txt"
done
done

for fa in ./COMBINED-DATA/*.fa
do
        lastname=$(basename "$fa" .fa)  # Extract filename without .fa
    awk -v prefix="$lastname" '{if ($0 ~ /^>/) print ">" prefix "_" sprintf("%05d", ++i); else print}' "$fa" > "$fa.tmp" && mv "$fa.tmp" "$fa"

done
