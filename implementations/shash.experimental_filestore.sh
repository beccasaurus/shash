# Stores hashes in files.
#
# The format is a bit silly, but it's unique.  We can always change it later.
#
#     |---:/ Rover \:---|
#     Golden Retriever
#     |---:\ Rover /:---|
#     |---:/ Snoopy \:---|
#     Beagle
#     |---:\ Snoopy /:---|
#

SHASH_IMPLEMENTATIONS="$SHASH_IMPLEMENTATIONS experimental_filestore"

shash_experimental_filestore() {
	method=$1; shift
	"shash_experimental_filestore__$method" "$@"
}

shash_experimental_filestore__get() { hash=$1; key=$2
	# parse the file for this hash (if it exists) for the given key
	# and get everything after the key up until the end of the file 
	# or the next key.
	filename="`shash_experimental_filestore__filename "$hash"`"
	if [ -f "$filename" ]; then
		sed -n "/^|---:\/ $key \\\\:---|$/,/^|---:\\\\ $key \/:---|$/{/^|---:/d;p}" "$filename"
	fi
}

shash_experimental_filestore__set() { hash=$1; key=$2; value=$3
	filename="`shash_experimental_filestore__filename "$hash"`"
	if [ -f "$filename" ]; then
		if [ -n "$( shash_experimental_filestore__get "$hash" "$key" )" ]; then
			shash_experimental_filestore__unset_hash_key "$hash" "$key"
		fi
	fi
	printf "|---:/ $key \:---|\n$value\n|---:\ $key /:---|\n" >> "$filename"
}

shash_experimental_filestore__keys() { hash=$1
	# parse the file for this hash (if it exists) for keys
	filename="`shash_experimental_filestore__filename "$hash"`"
	if [ -f "$filename" ]; then
		sed "/^|---:\/ \(.*\) \\\\:---|$/!d; s/^|---:\/ \(.*\) \\\\:---|$/\1/g" "`shash_experimental_filestore__filename "$hash"`"
	fi
}

shash_experimental_filestore__unset() { hash=$1; key=$2
	if [ -z "$key" ]; then
		shash_experimental_filestore__unset_hash "$hash"
	else
		shash_experimental_filestore__unset_hash_key "$hash" "$key"
	fi
}

shash_experimental_filestore__unset_hash() { hash=$1
	filename="`shash_experimental_filestore__filename "$hash"`"
	if [ -f "$filename" ]; then
		rm "$filename"
	fi
	shash_undeclare "$hash"
}

shash_experimental_filestore__unset_hash_key() { hash=$1; key=$2
	filename="`shash_experimental_filestore__filename "$hash"`"
	if [ -f "$filename" ]; then
		NEW_TEXT="$( sed "/^|---:\/ $key \\\\:---|$/,/^|---:\\\\ $key \/:---|$/d" "$filename" )"
		printf "$NEW_TEXT" > $filename
	fi
}

shash_experimental_filestore__filename() { hash=$1
	printf "${SHASH_EXPERIMENTAL_FILESTORE_SESSION_DIR}/$hash"
}

shash_experimental_filestore__new_session_id(){
	date +%Y-%m-%d_%H_%M_%S_%N
}

shash_experimental_filestore__new_session_dir(){
	if [ ! -d "$SHASH_EXPERIMENTAL_FILESTORE_DIR" ]; then
		mkdir -p "$SHASH_EXPERIMENTAL_FILESTORE_DIR"
	fi
	mktemp --directory --tmpdir="$SHASH_EXPERIMENTAL_FILESTORE_DIR" "$SHASH_EXPERIMENTAL_FILESTORE_SESSION.XXXXXX"
}

shash_experimental_filestore__clear_session() {
	if [ -n "$SHASH_EXPERIMENTAL_FILESTORE_SESSION_DIR" ] && [ -d "$SHASH_EXPERIMENTAL_FILESTORE_SESSION_DIR" ]; then
		rm -r "$SHASH_EXPERIMENTAL_FILESTORE_SESSION_DIR"
	fi
}

shash_experimental_filestore__reset_session() {
	shash_experimental_filestore__clear_session
	SHASH_EXPERIMENTAL_FILESTORE_SESSION="`shash_experimental_filestore__new_session_id`"
	SHASH_EXPERIMENTAL_FILESTORE_SESSION_DIR="`shash_experimental_filestore__new_session_dir`"
}

SHASH_EXPERIMENTAL_FILESTORE_DIR="/tmp/shash/"

shash_experimental_filestore__reset_session # this sets the original SESSION and SESSION_DIR globals for getting the session ID and directory
