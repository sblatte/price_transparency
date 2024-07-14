# read in and store the column names
NR==1 {for(i=1;i<=NF;i++) h[i]=$i; next}
BEGIN { FS="," } {
    # get number of columns and rows
    max_nf = NF
    max_nr = NR
    
    for (x = 1; x <= NF; x++)
        mat[x, NR] = $x
} END {
    printf "\nVariable: Mean; Missing\n"
    # loop through columns
    for (x = 1; x <= max_nf; x++) {
        # calculate the sum of the values in the column
        sum = 0.0
        missing = 0
        for (y = 2; y <= max_nr; y++) {
            sum += mat[x, y]
            if ( mat[x,y] == "") ++missing
        }
        mean = sum/(max_nr-1-missing) # calculate mean 
        printf("%s: %.2f; %.0f\n", h[x], mean, missing) # print with column name
    } 
}
