. ../shash.sh

describe "shash - PORTED FROM RSpec"

it_can_manually_get_and_set_keys_and_values() {
	# This will fail if new shell sessions aren't used for each test
	test "`shash dogs Rover`" "=" ""

	shash dogs Rover  retriever
	shash dogs Snoopy beagle

	test "`shash dogs Rover`"  "=" retriever
	test "`shash dogs Snoopy`" "=" beagle
}

it_uses_a_new_session_for_each_test() {
	# This will fail if new shell sessions aren't used for each test
	test "`shash dogs Rover`" "=" ""

	shash dogs Rover  retriever
	shash dogs Snoopy beagle

	test "`shash dogs Rover`"  "=" retriever
	test "`shash dogs Snoopy`" "=" beagle
}

it_can_get_and_set_keys_and_values_using_a_declared_shash() {
	# TODO switch this to 'declare' per shell conventions
	shash_define dogs

	test "`dogs Lander`" "=" ""
	dogs Lander "American Pitbull Terrier"
	test "`dogs Lander`" "=" "American Pitbull Terrier"

	test "`dogs Murdock`" "=" ""
	dogs Murdock "Australian Shepherd"
	test "`dogs Murdock`" "=" "Australian Shepherd"
}

it_can_use_keys_and_values_with_spaces_and_punctuation() {
	shash_define dogs

	test "`dogs "^Little @Monster"`" "=" ""
	dogs "^Little @Monster" "%Terrifying $ Little* Bastard~"
	test "`dogs "^Little @Monster"`" "=" "%Terrifying $ Little* Bastard~"
}

it_returns_all_key_names_and_values_when_called_without_a_key_or_value() {
	shash dogs Rover retriever
	test "`shash dogs`" "=" "Rover: retriever"

	shash dogs Lander "American Pitbull Terrier"
	test "`shash dogs`" "=" "Rover: retriever
Lander: American Pitbull Terrier"
}

it_shash_keys_returns_all_keys(){
	shash dogs Rover retriever
	test "`shash_keys dogs`" "=" "Rover"

	shash dogs Lander beagle
	test "`shash_keys dogs`" "=" "Rover
Lander"
}

it_shash_values_returns_all_values(){
	shash dogs Rover retriever
	test "`shash_values dogs`" "=" "retriever"

	shash dogs Lander beagle
	test "`shash_values dogs`" "=" "retriever
beagle"
}

it_can_delete_a_key_from_a_hash() {
        shash_define dogs
        dogs Rover retriever
        dogs Lander "American Pitbull Terrier"
        dogs Murdock "Australian Shepherd"
        dogs "Long Name" "A kind of dog"

        test "`dogs_keys`" "=" "Rover
Lander
Murdock
Long Name"

        shash_delete dogs Lander
        test "`dogs_keys`" "=" "Rover
Murdock
Long Name"

        dogs_delete "Long Name"
        test "`dogs_keys`" "=" "Rover
Murdock"

        dogs_delete Rover
        test "`dogs_keys`" "=" "Murdock"
}

it_can_easily_do_something_with_each_item() {
	shash_define dogs
	dogs Rover retriever
	dogs Murdock "Australian Shepherd"

	test "`dogs_each 'echo "$key is a $value"'`" "=" "Rover is a retriever
Murdock is a Australian Shepherd"
}

it_can_easily_print_out_something_for_each_item() {
	shash_define dogs
	dogs Rover retriever
	dogs Murdock "Australian Shepherd"

	test "`dogs_echo '$key is a $value'`" "=" "Rover is a retriever
Murdock is a Australian Shepherd"
}

it_can_use_dynamically_named_variables_for_each_hash_key() {
	test "$__shash__dogs__Rover" "=" ""
	shash dogs Rover retriever
	test "$__shash__dogs__Rover" "=" "retriever"
}

# NOTE
#
# Methods of persistance (ideas) ...
#
#  - dynamically named variables, 1 for each key
#  - dynamically named variables, 1 for each hash
#  - a file
#  - a BASH associative array ?
#  - a zsh associative array  ?
#
#  For file persistance, it would be nice to be able to share 
#  the same shash 'session' with another shell.  By default, 
#  we could set a token based on unix time (`date +%s`) but 
#  maybe you can also:
#  - list the available sessions
#  - create/join a named session
#
#  If we do this, we should implement some simple file locking 
#  for WRITES (which should be quick, append-only).
