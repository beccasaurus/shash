require File.dirname(__FILE__) + '/spec_helper'

describe 'shash' do
  include HelperMethods

  [ Session::Sh, Session::Bash ].each do |shell|
    describe shell do
      before { reset_session!(shell) }

      it 'session OK' do
        result('printf "$foo"').should == ''

        run 'foo=bar'
        result('printf "$foo"').should == 'bar'

        reset_session!
        result('printf "$foo"').should == ''
      end

      it 'can manually set/get keys from a hash' do
        run 'shash dogs Rover retriever'
        run 'shash dogs Snoopy beagle'

        result('shash dogs Rover' ).should == 'retriever'
        result('shash dogs Snoopy').should == 'beagle'
      end

      it 'can create a helper function to set/get keys from a particular hash' do
        run 'shash_define dogs'

        result('dogs Lander').should == ''
        run 'dogs Lander "American Pitbull Terrier"'
        result('dogs Lander').should == 'American Pitbull Terrier'

        result('dogs Murdock').should == ''
        run 'dogs Murdock "Australian Shepherd"'
        result('dogs Murdock').should == 'Australian Shepherd'
      end

      it 'can use keys and values with spaces and punctuation' do
        run 'shash_define dogs'

        result('dogs "^Little @Monster"').should == ''
        run 'dogs "^Little @Monster" "%Terrifying $ Little* Bastard~"'
        result('dogs "^Little @Monster"').should == '%Terrifying $ Little* Bastard~'
      end

      it 'when called without a key or value, all key names AND values are returned' do
        run 'shash dogs Rover retriever'
        result('shash dogs').should == "Rover: retriever"

        run 'shash dogs Lander "American Pitbull Terrier"'
        result('shash dogs').should == "Rover: retriever\nLander: American Pitbull Terrier"
      end

      it 'shash_keys hashname returns all keys' do
        run 'shash dogs Rover retriever'
        result('shash_keys dogs').should == "Rover"

        run 'shash dogs Lander beagle'
        result('shash_keys dogs').should == "Rover\nLander"
      end

      it 'shash_values hashname returns all values' do
        run 'shash dogs Rover retriever'
        result('shash_values dogs').should == "retriever"

        run 'shash dogs Lander beagle'
        result('shash_values dogs').should == "retriever\nbeagle"
      end

      it 'can delete a key from a hash' do
        run 'shash_define dogs'
        run 'dogs Rover retriever'
        run 'dogs Lander "American Pitbull Terrier"'
        run 'dogs Murdock "Australian Shepherd"'
        run 'dogs "Long Name" "A kind of dog"'

        result('dogs_keys').should == "Rover\nLander\nMurdock\nLong Name"

        run 'shash_delete dogs Lander'
        result('dogs_keys').should == "Rover\nMurdock\nLong Name"

        run 'dogs_delete "Long Name"'
        result('dogs_keys').should == "Rover\nMurdock"

        run 'dogs_delete Rover'
        result('dogs_keys').should == "Murdock"
      end

      it 'can easily do something for each item (without having to manually make a for loop)' do
        run 'shash_define dogs'
        run 'dogs Rover retriever'
        run 'dogs Murdock "Australian Shepherd"'
      
        result(%{dogs_each 'echo "$key is a $value"'}).should == "Rover is a retriever\nMurdock is a Australian Shepherd"
      end

      it 'can easily print out something for each item' do
        run 'shash_define dogs'
        run 'dogs Rover retriever'
        run 'dogs Murdock "Australian Shepherd"'
      
        result(%{dogs_echo '$key is a $value'}).should == "Rover is a retriever\nMurdock is a Australian Shepherd"
      end

      # Methods of persistance (ideas) ...
      #
      #  - dynamically named variables, 1 for each key
      #  - dynamically named variables, 1 for each hash
      #  - a file
      #  - a BASH associative array ?
      #  - a zsh associative array  ?
      context 'persistance techniques' do

        example '1 dynamically named variable for each hash key' do
          echo('$__shash__dogs__Rover').should == ''

          run 'shash dogs Rover retriever'

          echo('$__shash__dogs__Rover').should == 'retriever'
        end

      end
    end
  end

end
