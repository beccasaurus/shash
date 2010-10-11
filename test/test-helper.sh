. ./shash.sh
. ./sharray.sh

CR='
'

cleanup_if_experimental_filestore() {
	if [ "$SHASH_IMPLEMENTATION" = "experimental_filestore" ]; then
		rm -r /tmp/shash
		shash_experimental_filestore__reset_session
	fi
}
