# shash - Hash functionality for /bin/sh

shash() {
	hash="$1"; key="$2"; value="$3"

	if [ -z "$value" ]; then
		shash_get "$hash" "$key"
	else
		shash_set "$hash" "$key" "$value"
	fi
}

shash_set() {
	hash=$1; key=$2; value=$3
	varname=`shash_variable_name_for_hash_and_key "$hash" "$key"`
	eval "$varname='$value'"
}

shash_get() {
	hash=$1; key=$2
	varname=`shash_variable_name_for_hash_and_key "$hash" "$key"`
	eval "echo \$${varname}"
}

shash_variable_name_for_hash_and_key() {
	hash=$1; key=$2
	safe_hash=`echo "$hash" | sed 's/[^[:alnum:]]//g'`
	safe_key=` echo "$key"  | sed 's/[^[:alnum:]]//g'`
	echo "__shash__${safe_hash}__${safe_key}"
}

shash_define() {
	hash=$1

	eval "${hash}() {
		shash \"${hash}\" \"\$@\"
	}"
}
