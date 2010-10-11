. ./test-helper.sh

describe "sharray"

it_displays_usage_without_arguments() { # $ sharray
	usage=`sharray | head -n 1`
	test "$usage" "=" "Usage: sharray array_name [operation] [arguments]"
}

it_displays_values() { # $ sharray dog_names
	sharray dog_names push Rover
	sharray dog_names push "Long Name"
	sharray dog_names push Snoopy

	test "`sharray dog_names`" "=" "Rover${CR}Long Name${CR}Snoopy"
}

it_can_push_a_value_onto_array() { # $ sharray dog_names push Rover
	test "`sharray dog_names`" "=" ""
	sharray dog_names push Rover
	test "`sharray dog_names`" "=" "Rover"
}

it_can_push_values_onto_array() { # $ sharray dog_names push Rover Snoopy Rex
	test "`sharray dog_names`" "=" ""

	sharray dog_names push Rover "Long Name" Snoopy
	test "`sharray dog_names`" "=" "Rover${CR}Long Name${CR}Snoopy"
}
