# sharray - shash extension providing cross-shell compatible Arrays
# =================================================================

sharray() {
	array=$1
	operation=$2

	if [ -z "$array" ]; then
		printf "Usage: sharray array_name [operation] [arguments]"
	elif [ -z "$operation" ]; then
		shash_values "$array"
	else
		shift; shift; # shift the array and operation arguments
		"sharray_$operation" "$array" "$@"
	fi
}

sharray_push() {
	array=$1; shift
	while [ "$1" ]; do
		shash "$array" "`shash_length "$array"`" "$1"; shift
	done
}

# finish the function tests before testing the sharray DSL
#sharray_declare() {
#	array=$1
#
#}
