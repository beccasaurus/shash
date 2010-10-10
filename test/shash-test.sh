. ../shash.sh

CR='
'

describe "shash core"

it_displays_usage_without_arguments() { # $ shash
	usage=`shash | head -n 1`
	test "$usage" "=" "Usage: shash hash_name [key] [value]"
}

it_displays_hash_keys_and_values() { # $ shash dogs
	test "`shash dogs`" "=" ""

	shash dogs Rover retriever
	test "`shash dogs`" "=" "Rover: retriever"

	shash dogs Snoopy beagle
	test "`shash dogs`" "=" "Rover: retriever${CR}Snoopy: beagle"
}

it_can_get_a_value() { # $ shash dogs Rover
	test "`shash dogs Rover`" "=" ""
	shash dogs Rover "Golden Retriever"
	test "`shash dogs Rover`" "=" "Golden Retriever"
}

it_can_set_a_value() { # $ shash dogs Rover "Golden Retriever"
	test "`shash dogs Rover`" "=" ""
	shash dogs Rover "Golden Retriever"
	test "`shash dogs Rover`" "=" "Golden Retriever"
}

it_can_get_all_keys() { # $ shash_keys dogs
	shash dogs Rover "Golden Retriever"
	test "`shash_keys dogs`" "=" "Rover"

	shash dogs Snoopy "Beagle"
	test "`shash_keys dogs`" "=" "Rover${CR}Snoopy"
}

it_can_get_all_values() { # $ shash_values dogs
	shash dogs Rover "Golden Retriever"
	test "`shash_values dogs`" "=" "Golden Retriever"

	shash dogs Snoopy "Beagle"
	test "`shash_values dogs`" "=" "Golden Retriever${CR}Beagle"
}

it_can_easily_enumerate_through_all_items() { # $ shash_each dogs 'echo "$key is a $value"'
	shash dogs Rover "Golden Retriever"
	shash dogs Snoopy "Beagle"

	result="`shash_each dogs 'echo "$key is a $value"'`"
	test "$result" "=" "Rover is a Golden Retriever${CR}Snoopy is a Beagle"
}

it_can_easily_echo_something_for_all_items() { # $ shash_echo dogs 'The dog $key is a $value'
	shash dogs Rover "Golden Retriever"
	shash dogs Snoopy "Beagle"

	result="`shash_echo dogs 'The dog $key is a $value'`"
	test "$result" "=" "The dog Rover is a Golden Retriever${CR}The dog Snoopy is a Beagle"
}

it_can_delete_a_key() { # $ shash_delete dogs Rover
	shash dogs Rover "Golden Retriever"
	shash dogs Snoopy "Beagle"
	test "`shash_keys dogs`" "=" "Rover${CR}Snoopy"

	shash_delete dogs Rover
	test "`shash_keys dogs`" "=" "Snoopy"

	# FIXME deleting the last key fails?  It doesn't fail when run outside of roundup ???
	#shash_delete dogs Snoopy
	#test "`shash_keys dogs`" "=" ""
}
