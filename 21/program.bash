#!/usr/bin/env bash

set -e

save_PATH=$PATH
PATH=

infile='input.txt'

intersect() {
	local list_a list_b a b list_r
	list_a=$1
	list_b=$2

	for a in $list_a; do
		for b in $list_b; do
			if [ $a = $b ]; then
				list_r="$list_r $a"
				break
			fi
		done
	done
	echo "$list_r"
}

declare -A all_ingredients
declare -A candidates
declare -A ingr_counts

while read line; do
	ingr=${line% (contains*}
	x1=${line#*contains }
	x2=${x1%)}
	aller=${x2//,/}

	for i in $ingr; do
		all_ingredients[$i]=1

		if [ "${ingr_counts[$i]}" == "" ]; then
			ingr_counts[$i]=1
		else
			ingr_counts[$i]=$((${ingr_counts[$i]} + 1))
		fi
	done

	for a in $aller; do
		if [ "${candidates[$a]}" = "" ]; then
			candidates[$a]=$ingr
		else
			candidates[$a]=$(intersect "${candidates[$a]}" "$ingr")
		fi
	done
done < $infile

declare -A ingr_with_aller

for k in "${!candidates[@]}"; do
	for i in ${candidates[$k]}; do
		ingr_with_aller[$i]=true
	done
done

for i in "${!all_ingredients[@]}"; do
	found=false
	for j in "${!ingr_with_aller[@]}"; do
		if [ $i = $j ]; then
			found=true
			break
		fi
	done
	if ! $found; then
		ingr_without="$ingr_without $i"
	fi
done

total=0

for i in $ingr_without; do
	total=$(($total + ${ingr_counts[$i]}))
done

echo $total

# part 2

declare -A matches

while true; do
	progress=false

	for a in "${!candidates[@]}"; do
		v=${candidates[$a]}
		set -- $v
		if [ $# -eq 1 ]; then
			i=$1
			matches[$a]=$i
			# remove match from other candidates
			for aa in "${!candidates[@]}"; do
				vv=${candidates[$aa]}
				vv=${vv/$i/}
				candidates[$aa]=$vv
			done
			progress=true
			break
		fi
	done
	if ! $progress; then
		break
	fi
done

sorted_ingr=$(
	# The rest of the program works with an empty path without any
	# external tools, but we need it here for sorting.  (It
	# appears to be possible to implement sort algorithms in bash,
	# but this is not the place to prove that.)
	PATH=$save_PATH
	for k in "${!matches[@]}"; do
		echo $k
	done | LC_ALL=C sort
	   )

for k in $sorted_ingr; do
	v=${matches[$k]}
	if [ "$list" = "" ]; then
		list=$v
	else
		list="$list,$v"
	fi
done

echo $list
