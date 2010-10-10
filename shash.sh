# shash - Hash functionality for /bin/sh
# ======================================

# Public API

# TODO move all of the implementation dependent methods into a default "implementation"

shash() {
	hash=$1; key=$2; value=$3

	if [ -z "$hash" ]; then
		printf "Usage: shash hash_name [key] [value]"
	elif [ -z "$key" ]; then
		shash_keys_and_values "$hash"
	elif [ -z "$value" ]; then
		__shash_get "$hash" "$key"
	else
		__shash_set "$hash" "$key" "$value"
	fi
}

shash_keys() {
	hash=$1
	keys_varname=`__shash_variable_name_for_hash_keys "$hash"`
	eval "printf \"\$$keys_varname\""
}

shash_values() {
	hash=$1
	shash_echo "$hash" '$value'
}

shash_keys_and_values() {
	hash=$1
	shash_echo "$hash" '$key: $value'
}

shash_each() {
	hash=$1; code=$2
	for key in `shash_keys "$hash"`; do
		value=`__shash_get "$hash" "$key"`
		eval "$code"
	done
}

shash_echo() {
	hash=$1; code=$2
	shash_each "$hash" "echo \"$code\""
}

shash_delete() {
	hash=$1; key=$2

	# unset the actual variable
	hash_and_key_variable=`__shash_variable_name_for_hash_and_key "$hash" "$key"`
	eval "unset $hash_and_key_variable"

	# remove the key from our list of keys
	keys_varname=`__shash_variable_name_for_hash_keys "$hash"`
	old_keys=`shash_keys "$hash"`
	new_keys=`echo "$old_keys" | grep -v "^${key}$"`
	eval "${keys_varname}=\"$new_keys\""
}

# Defining your own Hash helper function

shash_define() {
	hash=$1
eval "
	${hash}() {
		shash \"${hash}\" \"\$@\"
	}
	${hash}_keys() {
		shash_keys \"${hash}\"
	}
	${hash}_values() {
		shash_values \"${hash}\"
	}
	${hash}_delete() {
		shash_delete \"${hash}\" \"\$@\"
	}
	${hash}_each() {
		shash_each \"${hash}\" \"\$@\"
	}
	${hash}_echo() {
		shash_echo \"${hash}\" \"\$@\"
	}
"
}

# Private functions

__shash_variable_name_for_hash_keys() {
	varname=`__shash_safe_variable_name "$1"`
	printf "__shash__${varname}__keys"
}

__shash_variable_name_for_hash_and_key() {
	hash=$1; key=$2
	safe_hash=`__shash_safe_variable_name "$hash"`
	safe_key=` __shash_safe_variable_name "$key"`
	printf "__shash__${safe_hash}__${safe_key}"
}

__shash_safe_variable_name() {
	printf "`printf "$1" | sed 's/[^[:alnum:]]//g'`"
}

__shash_set() {
	hash=$1; key=$2; value=$3

	# set variable for this key
	varname=`__shash_variable_name_for_hash_and_key "$hash" "$key"`
	eval "$varname='$value'"

	# update the variable that stores the names of all keys for this hash
	keys_varname=`__shash_variable_name_for_hash_keys "$hash"`
	eval "${keys_varname}=\"\${${keys_varname}}${key}\n\""
}

__shash_get() {
	hash=$1; key=$2
	varname=`__shash_variable_name_for_hash_and_key "$hash" "$key"`
	eval "echo \$${varname}"
}

