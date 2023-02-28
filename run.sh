#!/bin/bash

# Define variables
receptor=rec.pdb
ligand=lig.pdb
autobox_ligand=lig.pdb
num_modes=1

# Run molecular docking and save output to hasil_simulasi.txt
for i in {1..10}
do
    gnina -r $receptor -l $ligand --autobox_ligand $autobox_ligand -o output_${i}.pdb --num_modes $num_modes >> hasil_simulasi.txt
done

# Define the reference structure
reference="lig.pdb"

# Initialize variables for calculating mean RMSD
sum_rmsd=0
count=0

# Loop over each file and calculate the RMSD
for i in {1..10}
do
    # Define the target structure
    target="output_${i}.pdb"
    
    # Calculate the RMSD
    rmsd=$(obrms -f $reference $target | awk '{print $3}')
    
    # Add RMSD to sum and increment count
    sum_rmsd=$(echo "$sum_rmsd + $rmsd" | bc -l)
    count=$((count+1))
    
    # Print the result
    echo "RMSD of $target compared to $reference: $rmsd"
    
    # Save the result to a file
    echo "RMSD of $target compared to $reference: $rmsd" >> rmsd.txt
done

# Calculate the mean RMSD
mean_rmsd=$(echo "scale=3; $sum_rmsd / $count" | bc -l)

# Print the mean RMSD
echo "Mean RMSD: $mean_rmsd"

# Save the mean RMSD to a file
echo "Mean RMSD: $mean_rmsd" >> rmsd.txt

