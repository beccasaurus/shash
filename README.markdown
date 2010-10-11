#  shash
## Hashes for /bin/sh Shell

Although some unix shells like BASH support associative arrays, I wanted better "Hash tables" when writing shell scripts.

This provides hash-like functionality with a pleasant syntax.

It is compatible with /bin/sh and should be compatible with all of its descendants, eg. BASH and zsh

## Usage

To view this example code: [example.sh](/remi/shash/blob/master/examples/example.sh)

    . shash.sh

    shash_declare dogs

    dogs Snoopy     Beagle
    dogs Scooby-Doo "Great Dane"
    dogs Lady       "Cocker Spaniel"
    dogs Tramp      Mutt

Now that you have a few items in your Hash, there are a few ways you can use them ...

    $ dogs Snoopy
    Beagle

    $ dogs_keys
    Snoopy
    Scooby-Doo
    Lady
    Tramp

    $ dogs_values
    Beagle
    Great Dane
    Cocker Spaniel
    Mutt

    $ dogs
    Snoopy: Beagle
    Scooby-Doo: Great Dane
    Lady: Cocker Spaniel
    Tramp: Mutt

    $ dogs_echo 'The dog named $key is a $value'
    The dog named Snoopy is a Beagle
    The dog named Scooby-Doo is a Great Dane
    The dog named Lady is a Cocker Spaniel
    The dog named Tramp is a Mutt

    for key in `dog_keys`; do echo "$key is a `dogs "$key"`"; done
    Snoopy is a Beagle
    Scooby-Doo is a Great Dane
    Lady is a Cocker Spaniel
    Tramp is a Mutt

## Tests

[roundup](http://bmizerany.github.com/roundup/) is required to run the tests.

    $ git clone git@github.com:remi/shash.git
    $ cd shash/
    $ ./run-tests

Here is the current test output, displaying usage examples.  (This uses my fork of roundup to display the command syntax)

    shash
      $ shash:                                         [PASS]
      $ shash dogs:                                    [PASS]
      $ shash dogs Rover:                              [PASS]
      $ shash dogs Rover "Golden Retriever":           [PASS]
      $ shash_keys dogs:                               [PASS]
      $ shash_values dogs:                             [PASS]
      $ shash_each dogs 'echo "$key is a $value"':     [PASS]
      $ shash_echo dogs 'The dog $key is a $value':    [PASS]
      $ shash_delete dogs Rover:                       [PASS]
      $ shash_length dogs:                             [PASS]
      $ shash_declare dogs:                            [PASS]
      $ shash_unset dogs:                              [PASS]
    shash dsl
      $ dogs:                                          [PASS]
      $ dogs Rover:                                    [PASS]
      $ dogs Rover "Golden Retriever":                 [PASS]
      $ dogs_keys:                                     [PASS]
      $ dogs_values dogs:                              [PASS]
      $ dogs_each 'echo "$key is a $value"':           [PASS]
      $ dogs_echo 'The dog $key is a $value':          [PASS]
      $ dogs_delete Rover:                             [PASS]
      $ dogs_length:                                   [PASS]
    =========================================================
    Tests:   21 | Passed:  21 | Failed:   0

We have more than 1 implementation of shash.  We also like to make sure that shash always works with /bin/sh as well as BASH.  To run a full test, you might 
want to run something like this:
