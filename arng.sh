#!/bin/bash

# Display help
if [ "$1" == "-h" ]; then

  echo "
-----------------------------------------------------------
Active Response Network Generator - INSTRUCTIONS/HELP PAGE
-----------------------------------------------------------

RUN AS :
--------

$ bash arng.sh -d condition_si(file) -c control_si(file) -n network(file) -p percentile_cut-off(value) -f upper_fold_change_cut-off(value)


PARAMETERS
----------

-d -> Tab delimited file having the normalised signal intensity for genes in the condition of interest given as GENE""'\t'""Normalised_signal_instensity. 

-c -> Tab delimited file having the normalised signal intensity for genes in the control condition given as GENE""'\t'""Normalised_signal_instensity.

-n -> Tab delimited network file given as: NODE_A""'\t'""NODE_B

-f ->  Upper fold change cut-off. Not log normalised.

-p -> Top percentile cut-off

NOTE: In files -d and -c, the expression values should be normalised signal intensities or counts, they should not be log transformed. All files supplied to the script should be in the RNG/ directory.

------------

-h -> Displays this help page.

DEPENDENCIES
------------

* Linux with minimum 8GB of RAM and 160GB of storage space
* Perl (v>5)
* Python (v>2.7) & Python dependencies: networkx, zen, numpy, cython
"
  exit 0
fi

# Setting parameters
while [ "$1" != "" ]; do
    case $1 in
        -d | --condition_si )           shift
                                        d=$1
                                        ;;
        -c | --control_si )             shift
                                        c=$1
                                        ;;
        -n | --network )                shift
                                        n=$1
                                        ;;
        -p | --cut-off )                shift
                                        p=$1
                                        ;;
        -f | --fold_change_cut-off )    shift
                                        f=$1
                                        ;;
        * )                             usage
                                        exit 1
    esac
    shift
done

#Begin Analysis
echo "-------------------------------------
Active Response Network Generator
-------------------------------------" > log.txt
echo "TASK                 : TIME
Reading input files  : `date | awk '{print $4}'` 
Condition file       : $d
Control file         : $c
Network file         : $n
Fold Change cut-off  : $f
Percentile cut-off   : $p" >> log.txt

start=`date +%s`

# Calculating fold change, DEG's and node weight
echo "Calculating fold change.." `date | awk '{print $4}'` >> log.txt
paste -d "\t" <(sort $d | awk '{print $0}') <(sort $c | awk '{print $2}') > sigint.txt
awk '{print $1"\t"$2/$3}' sigint.txt > fc_$d

echo "Identifying DEG's.." `date | awk '{print $4}'` >> log.txt
awk '{if($2>='"$f"') print $1}' fc_$d > up_deg_$d # specify DEG cut-off for up-regulated genes

echo "Calculating node weights.." `date | awk '{print $4}'` >> log.txt
paste <(sort $d | awk '{print $0}') <(awk '{print $2}' fc_$d) | awk '{print $1"\t"$2*$3}' > nw_$d

# Calculating edge weights
# Condition -d with FC
echo "Calculating edge weights.." `date | awk '{print $4}'` >> log.txt
awk '{print $1}' $n > intA.txt
awk '{print $2}' $n > intB.txt
awk -f vlookup.awk nw_$d intA.txt > nwa.txt
awk -f vlookup.awk nw_$d intB.txt > nwb.txt
paste -d '\t' <(awk '{print $1}' nwa.txt) <(awk '{print $1}' nwb.txt) <(awk '{print $2}' nwa.txt) <(awk '{print $2}' nwb.txt) | awk '{if($3!="NA" && $4!="NA")print $0}' > abnwebt.txt
awk '{printf "%s\t%s\t%.4f\n",$1,$2,(($3*$4)^0.5);}' abnwebt.txt > ew.txt
awk '{printf "%s\t%s\t%.4f\n" ,$1,$2,$3}' ew.txt > ewt.txt
a=`awk '{print $3}' ewt.txt | sort -nk1 | head -1`
b=`awk '{print $3}' ewt.txt | sort -nrk1 | head -1`
aplusb=`echo "scale=3;$a+$b" | bc`
awk '{printf "%s\t%s\t%.6f\n", $1,$2,(100-($3/'"$aplusb"')*100)}' ewt.txt > ew_$d # Normalisation of EW
rm -f nwa.txt nwb.txt abnwebt.txt ew.txt ewt.txt

# Condition -c
awk -f vlookup.awk $c intA.txt > nwa.txt
awk -f vlookup.awk $c intB.txt > nwb.txt
paste -d '\t' <(awk '{print $1}' nwa.txt) <(awk '{print $1}' nwb.txt) <(awk '{print $2}' nwa.txt) <(awk '{print $2}' nwb.txt) | awk '{if($3!="NA" && $4!="NA")print $0}' > abnwebt.txt
awk '{printf "%s\t%s\t%.4f\n",$1,$2,(($3*$4)^0.5);}' abnwebt.txt > ew.txt
awk '{printf "%s\t%s\t%.4f\n" ,$1,$2,$3}' ew.txt > ewt.txt
a=`awk '{print $3}' ewt.txt | sort -nk1 | head -1`
b=`awk '{print $3}' ewt.txt | sort -nrk1 | head -1`
aplusb=`echo "scale=3;$a+$b" | bc`
#awk '{printf "%s\t%s\t%.4f\n", $1,$2,'"$aplusb"'-$3}' ewt.txt > ew_$c
awk '{printf "%s\t%s\t%.6f\n", $1,$2,(100-($3/'"$aplusb"')*100)}' ewt.txt > ew_$c # Normalisation of EW
rm -f intA.txt intB.txt nwa.txt nwb.txt abnwebt.txt ew.txt ewt.txt sigint.txt

# Computing shortest paths
echo "Computing shortest paths.." `date | awk '{print $4}'` >> log.txt
echo "Reading ew_$c" >> log.txt
python2.7 shortest_path.py ew_$c
echo "done.." `date | awk '{print $4}'` >> log.txt
echo "Reading ew_$d" >> log.txt
python2.7 shortest_path.py ew_$d
echo "done.." `date | awk '{print $4}'` >> log.txt

echo "Sorting shortest paths.." `date | awk '{print $4}'` >> log.txt
perl sort.pl -f sh_paths_ew_$c -c1 -n > sorted_shpaths_$c
perl sort.pl -f sh_paths_ew_$d -c1 -n > sorted_shpaths_$d

# Computing top path
# For $d
echo "Computing top paths.." `date | awk '{print $4}'` >> log.txt
awk '{print $2}' sorted_shpaths_$d > cld
sort -unk1 cld > scld
awk '$1>p{c++} {$2=c; print; p=$1}' OFS='\t' scld> ranked
rm -f cld scld
counter=`tail -1 ranked | awk '{print $2}'`
rank_cutoff=`echo "scale=3;$counter * $p/100" | bc`
score_cutoff=`awk '{if($2<='"$rank_cutoff"') print $1}' ranked | tail -1`
awk '{if($2<='"$score_cutoff"') print $0}' sorted_shpaths_$d > p$d
sed 's/^/,/g' p$d | sed 's/\t/,\t/g' > comma_sorted_shpaths_$d
cat up_deg_$d | while read i; do echo $i `grep -n ",$i," comma_sorted_shpaths_$d | head -1 | sed 's/:/ /g'` ; done | awk '{if($2>0) print $0}' > tpa_paths_$d
awk '{print $1}' tpa_paths_$d > imp_deg_p$d
rm -f ranked comma_sorted_shpaths_$d

#For $c
awk '{print $2}' sorted_shpaths_$c > clc
sort -unk1 clc > sclc
awk '$1>p{c++} {$2=c; print; p=$1}' OFS='\t' sclc > ranked
rm -f clc sclc
counter=`tail -1 ranked | awk '{print $2}'`
rank_cutoff=`echo "scale=3;$counter * $p/100" | bc`
score_cutoff=`awk '{if($2<='"$rank_cutoff"') print $1}' ranked | tail -1`
awk '{if($2<='"$score_cutoff"') print $0}' sorted_shpaths_$c > p$c
rm -f ranked

awk '{print $1}' p$d > pp$d
awk '{print $1}' p$c > pp$c
sort pp$d pp$c | uniq -d > cpp$d$c
sort cpp$d$c pp$d | uniq -u > uniq_pp$d
sort cpp$d$c pp$c | uniq -u > uniq_pp$c
awk '{print ","$0","}' uniq_pp$d > comma_uniq_pp$d

cat imp_deg_p$d | while read i; do grep ",$i," comma_uniq_pp$d ; done | sort -u | sed 's/^.\(.*\).$/\1/' > imp_uniq_pp$d

rm -f comma_uniq_pp$d

# Identifying important DEG's in the top network
echo "Identifying important DEG's in the top network" `date | awk '{print $4}'` >> log.txt
perl try-path-edit.pl uniq_pp$d | sed 's/ /\n/g' | sed '/^$/d' | sort -u > topnet_$d
awk '{print ","$0","}' imp_uniq_pp$d  > comma_imp_uniq_pp$d
cat up_deg_$d | while read i; do echo $i `grep -n ",$i," comma_imp_uniq_pp$d | head -1 `; done | awk '{if($2>0) print $1}' > imp_deg_$d
rm -f comma_imp_uniq_pp$d

# Create Readme
echo "

				**************                            
				** README!! **
				**************

This pipeline generates the following output files (sorted based on alphabetical order):

* ew_$c & ew_$d : Edge weight of $c & $d used to compute shortest paths.

* fc_$d : Fold change calculated as $d/$c.

* imp_deg_$d : This file contains a list of genes that meet the following criteria:

		#.) $f fold upregulated in condition $d
		#.) Participate in the paths unique to top $p % of the $d network.

* log.txt : Log file for geeks, listing all steps performed by the pipeline and the time taken.

* nw_$d : Node weights of $d used to compute the Edge weights.

* READ_ME.txt : This read me file.

* sorted_shpaths_$c & sorted_shpaths_$d : Shortest paths of $c & $d, sorted based on normalised path cost.

* topnet_$d : Breakdown network of uniq_pp$d (Paths that occur in the top $p % of $d condition and are not taken in $c condition)

* uniq_pp$d : Paths that occur in the top $p % of $d condition and are not taken in $c condition.

* up_deg_$d : Upper differentially expressed genes based on $f fold change as specified by the user.

	*********************************************************************************************
	***   Authors: Abhinandan Devaprasad, Abhilash Mohan, Awanti Sambarey, Nagasuma Chandra   ***
	***                                                                                       ***  
	***            Send queries to Abhinandan Devaprasad at abhi2308@gmail.com                *** 
	*********************************************************************************************

" > READ_ME.txt

# Compiling results
echo "Compiling results.." `date | awk '{print $4}'` >> log.txt
mkdir out_arng_${d}_${c}_${f}_${p}/
mv ew_$c ew_$d fc_$d imp_deg_$d nw_$d READ_ME.txt sorted_shpaths_$c sorted_shpaths_$d topnet_$d uniq_pp$d up_deg_$d out_arng_${d}_${c}_${f}_${p}/

# Deleting temporary files
echo "Deleting temporary files.." `date | awk '{print $4}'` >> log.txt
rm -rf cpp$d$c imp_deg_p$d p$c p$d pp$c pp$d sh_paths_ew_$c sh_paths_ew_$d tpa_paths_$d uniq_pp$c imp_uniq_pp$d

# INITIATE END SEQUENCE
echo "Ending analysis for.." $d $c $n `date | awk '{print $4}'` >> log.txt
end=`date +%s`
runtime=`echo "scale=3;($end - $start)/60" | bc`
echo "----------------------------------------" >> log.txt
echo "Total run time (in minutes) : " $runtime >> log.txt
echo "----------------------------------------" >> log.txt

# End & move log to output 
mv log.txt out_arng_${d}_${c}_${f}_${p}/
