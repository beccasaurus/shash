SHASH_IMPLEMENTATIONS="$SHASH_IMPLEMENTATIONS crappy_vars"

shash_crappy_vars() {
	method=$1; shift
	"shash_crappy_vars__$method" "$@"
}

shash_crappy_vars__reset() {
	:
}

shash_crappy_vars__get() { hash=$1; key=$2
	varname=`shash_crappy_vars__variable_name_for_hash_and_key "$hash" "$key"`
	eval "echo \$${varname}"
}

shash_crappy_vars__set() { hash=$1; key=$2; value=$3;
	# set variable for this key
	varname=`shash_crappy_vars__variable_name_for_hash_and_key "$hash" "$key"`
	eval "$varname='$value'"

	echo "!@#$%^&* THE KEYS: `shash_crappy_vars__keys`" 2>&1
	if [ -z "$( shash_crappy_vars__keys "$hash" | grep "^${key}$" )" ]; then
		# update the variable that stores the names of all keys for this hash
		keys_varname=`shash_crappy_vars__variable_name_for_hash_keys "$hash"`
		eval "${keys_varname}=\"\${${keys_varname}}${key}\n\""
	fi
}

shash_crappy_vars__keys() { hash=$1;
	keys_varname=`shash_crappy_vars__variable_name_for_hash_keys "$hash"`
	eval "printf \"\$$keys_varname\""
}

shash_crappy_vars__unset() { hash=$1; key=$2;
	if [ -z "$key" ]; then
		shash_crappy_vars__unset_entire_hash "$hash"
	else
		shash_crappy_vars__unset_hash_key "$hash" "$key"
	fi
}

shash_crappy_vars__unset_hash_key() { hash=$1; key=$2;
	# unset the actual variable
	hash_and_key_variable=`shash_crappy_vars__variable_name_for_hash_and_key "$hash" "$key"`
	eval "unset $hash_and_key_variable"

	# remove the key from our list of keys
	keys_varname=`shash_crappy_vars__variable_name_for_hash_keys "$hash"`
	old_keys=`shash_keys "$hash"`
	new_keys=`echo "$old_keys" | grep -v "^${key}$"`
	eval "${keys_varname}=\"$new_keys\""
}

shash_crappy_vars__unset_entire_hash() { hash=$1;
	# unset each hash/key variable
	for key in `shash_keys "$hash"`; do
		unset `shash_crappy_vars__variable_name_for_hash_and_key "$hash" "$key"`
	done

	# unset the variable that holds all key names
	unset `shash_crappy_vars__variable_name_for_hash_keys "$hash"`

	# unset all of the functions
	shash_undeclare "$hash"
}

shash_crappy_vars__variable_name_for_hash_keys() {
	varname=`shash_crappy_vars__safe_variable_name "$1"`
	printf "__shash__${varname}__keys"
}

shash_crappy_vars__variable_name_for_hash_and_key() { hash=$1; key=$2:
	safe_hash=`shash_crappy_vars__safe_variable_name "$hash"`
	safe_key=` shash_crappy_vars__safe_variable_name "$key"`
	printf "__shash__${safe_hash}__${safe_key}"
}

shash_crappy_vars__safe_variable_name() {
	printf "`printf "$1" | sed 's/[^[:alnum:]]//g'`"
}
