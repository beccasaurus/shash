. ./test-helper.sh

describe "shash dsl"

before() {
	shash_declare dogs
}

it_displays_hash_keys_and_values() { # $ dogs
	test "`dogs`" "=" ""

	dogs Rover retriever
	test "`dogs`" "=" "Rover: retriever"

	dogs Snoopy beagle
	test "`dogs`" "=" "Rover: retriever${CR}Snoopy: beagle"
}

it_can_get_a_value() { # $ dogs Rover
	test "`dogs Rover`" "=" ""
	dogs Rover "Golden Retriever"
	test "`dogs Rover`" "=" "Golden Retriever"
}

it_can_set_a_value() { # $ dogs Rover "Golden Retriever"
	test "`dogs Rover`" "=" ""
	dogs Rover "Golden Retriever"
	test "`dogs Rover`" "=" "Golden Retriever"
}

it_can_get_all_keys() { # $ dogs_keys
	dogs Rover "Golden Retriever"
	test "`dogs_keys`" "=" "Rover"

	dogs Snoopy "Beagle"
	test "`dogs_keys`" "=" "Rover${CR}Snoopy"
}

it_can_get_all_values() { # $ dogs_values dogs
	dogs Rover "Golden Retriever"
	test "`dogs_values`" "=" "Golden Retriever"

	dogs Snoopy "Beagle"
	test "`dogs_values`" "=" "Golden Retriever${CR}Beagle"
}

it_can_easily_enumerate_through_all_items() { # $ dogs_each 'echo "$key is a $value"'
	dogs Rover "Golden Retriever"
	dogs Snoopy "Beagle"

	result="`dogs_each 'echo "$key is a $value"'`"
	test "$result" "=" "Rover is a Golden Retriever${CR}Snoopy is a Beagle"
}

it_can_easily_echo_something_for_all_items() { # $ dogs_echo 'The dog $key is a $value'
	dogs Rover "Golden Retriever"
	dogs Snoopy "Beagle"

	result="`dogs_echo 'The dog $key is a $value'`"
	test "$result" "=" "The dog Rover is a Golden Retriever${CR}The dog Snoopy is a Beagle"
}

it_can_delete_a_key() { # $ dogs_delete Rover
	dogs Rover "Golden Retriever"
	dogs Snoopy "Beagle"
	test "`dogs_keys`" "=" "Rover${CR}Snoopy"

	dogs_delete Rover
	test "`dogs_keys`" "=" "Snoopy"

	# FIXME
	# deleting the last key blows up in roundup, but works normally
}

it_can_get_the_number_of_keys_in_a_hash() { # $ dogs_length
	test "`dogs_length`" "=" "0"

	dogs Rover "Golden Retriever"
	test "`dogs_length`" "=" "1"

	dogs Snoopy "Beagle"
	test "`dogs_length`" "=" "2"
}
