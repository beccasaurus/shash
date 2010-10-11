# shash - Hash functionality for /bin/sh
# ======================================

SHASH_IMPLEMENTATIONS=""
if [ -z "$SHASH_IMPLEMENTATION" ]; then SHASH_IMPLEMENTATION=crappy_vars; fi

. ./implementations/shash.crappy_vars.sh
. ./implementations/shash.experimental_filestore.sh

# Public API
#
# These functions are NOT implementation dependent.
# They should all use the current shash_implementation

shash() { hash=$1; key=$2; value=$3;

	if [ -z "$hash" ]; then
		printf "Usage: shash hash_name [key] [value]"
	elif [ -z "$key" ]; then
		shash_keys_and_values "$hash"
	elif [ -z "$value" ]; then
		shash_call get "$hash" "$key"
	else
		shash_call set "$hash" "$key" "$value"
	fi
}

# Implementations need to provide 1 function with a name formatted as: shash_[implementation name]
#
# This function needs to respond to a few calls:
#
#     get $hash $key
#     set $hash $key $value
#     keys $hash
#     unset $hash
#     unset $hash $key
#
shash_implementation() { implementation=$1;
	if [ -z "$implementation" ]; then
		for available_implementation in $SHASH_IMPLEMENTATIONS; do
			if [ "$available_implementation" = "$SHASH_IMPLEMENTATION" ]; then
				printf "* $available_implementation\n"
			else
				printf "  $available_implementation\n"
			fi
		done
	else
		SHASH_IMPLEMENTATION="$implementation"
	fi
}

shash_call() {
	"shash_${SHASH_IMPLEMENTATION}" "$@"
}

shash_keys() { hash=$1;
	shash_call keys "$hash"
}

shash_values() { hash=$1;
	shash_echo "$hash" '$value'
}

shash_keys_and_values() { hash=$1;
	shash_echo "$hash" '$key: $value'
}

shash_length() { hash=$1;
	printf "`shash_keys "$hash" | wc -l`"
}

shash_each() { hash=$1; code=$2;
	old_ifs=$IFS
	IFS='
'
	for key in `shash_keys "$hash"`; do
		value=`shash_call get "$hash" "$key"`
		eval "$code"
	done
	IFS=$old_ifs
}

shash_echo() { hash=$1; code=$2;
	shash_each "$hash" "echo \"$code\""
}

shash_delete() { hash=$1; key=$2;
	shash_call unset "$hash" "$key"
}

shash_declare() { hash=$1;
	# Defines the main function, eg. 'dogs'
	eval "${hash}() { shash \"${hash}\" \"\$@\"; }"

	# Defines the additional functions, eg. 'dogs_keys' and 'dogs_values'
	for method in keys values delete each echo length; do
		eval "${hash}_${method}() { shash_${method} \"${hash}\" \"\$@\"; }"
	done
}

shash_undeclare() { hash=$1
	unset -f "$hash"
	for method in keys values delete each echo length; do
		unset -f "${hash}_${method}"
	done
}

shash_unset() { hash=$1;
	shash_call unset "$hash"
}
