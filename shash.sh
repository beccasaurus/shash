# shash - Hash functionality for /bin/sh

shash() {
	hash=$1; key=$2; value=$3

	if [ -z "$value" ]; then
		shash_get $hash $key
	else
		shash_set $hash $key $value
	fi
}

shash_set() {
	hash=$1; key=$2; value=$3
	eval "__shash__${hash}__${key}=${value}"
}

shash_get() {
	hash=$1; key=$2
	eval "echo \$__shash__${hash}__${key}"
}
