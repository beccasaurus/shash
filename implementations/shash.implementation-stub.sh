SHASH_IMPLEMENTATIONS="$SHASH_IMPLEMENTATIONS STUB"

shash_STUB() {
	method=$1; shift
	"shash_STUB__$method" "$@"
}

shash_STUB__get() { hash=$1; key=$2
	echo "NOT IMPLEMENTED YET [shash_STUB__get($@)]"
}

shash_STUB__set() { hash=$1; key=$2; value=$3
	echo "NOT IMPLEMENTED YET  [shash_STUB__set($@)]"
}

shash_STUB__keys() { hash=$1
	echo "NOT IMPLEMENTED YET  [shash_STUB__keys($@)]"
}

shash_STUB__unset() { hash=$1; key=$2
	if [ -z "$key" ]; then
		shash_STUB__unset_hash "$hash"
	else
		shash_STUB__unset_hash_key "$hash" "$key"
	fi
}

shash_STUB__unset_hash() { hash=$1
	echo "NOT IMPLEMENTED YET  [shash_STUB__unset_hash($@)]"
}

shash_STUB__unset_hash_key() { hash=$1; hey=$2
	echo "NOT IMPLEMENTED YET  [shash_STUB__unset_hash_key($@)]"
}
