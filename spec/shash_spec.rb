require 'rubygems'
require 'bundler/setup'
Bundler.require

describe 'shash' do

  def reset_session! shell_class = Session::Sh
    @shell = shell_class.new
    @shell.execute ". #{File.dirname(__FILE__)}/../shash.sh"
  end

  def run cmd
    stdout, stderr = @shell.execute "#{cmd} 2>&1" # redirect all stderr to stdout
    stdout.to_s.chomp
  end

  [ Session::Sh, Session::Bash ].each do |shell|
    describe shell do
      before { reset_session!(shell) }

      it 'session OK' do
        run('printf "$foo"').should == ''

        run 'foo=bar'
        run('printf "$foo"').should == 'bar'

        reset_session!
        run('printf "$foo"').should == ''
      end

      it 'can manually set/get keys from a hash' do
        run 'shash dogs Rover retriever'
        run 'shash dogs Snoopy beagle'

        run('shash dogs Rover' ).should == 'retriever'
        run('shash dogs Snoopy').should == 'beagle'
      end

      it 'can create a helper function to set/get keys from a particular hash' do
        run 'shash_define dogs'

        run('dogs Lander').should == ''
        run 'dogs Lander "American Pitbull Terrier"'
        run('dogs Lander').should == 'American Pitbull Terrier'

        run('dogs Murdock').should == ''
        run 'dogs Murdock "Australian Shepherd"'
        run('dogs Murdock').should == 'Australian Shepherd'
      end

      it 'can use keys and values with spaces and punctuation' do
        run 'shash_define dogs'

        run('dogs "^Little @Monster"').should == ''
        run 'dogs "^Little @Monster" "%Terrifying $ Little* Bastard~"'
        run('dogs "^Little @Monster"').should == '%Terrifying $ Little* Bastard~'
      end

      it 'when called without a key or value, all key names AND values are returned' do
        run 'shash dogs Rover retriever'
        run('shash dogs').should == "Rover: retriever"

        run 'shash dogs Lander "American Pitbull Terrier"'
        run('shash dogs').should == "Rover: retriever\nLander: American Pitbull Terrier"
      end

      it 'shash_keys hashname returns all keys' do
        run 'shash dogs Rover retriever'
        run('shash_keys dogs').should == "Rover"

        run 'shash dogs Lander beagle'
        run('shash_keys dogs').should == "Rover\nLander"
      end

      it 'shash_values hashname returns all values' do
        run 'shash dogs Rover retriever'
        run('shash_values dogs').should == "retriever"

        run 'shash dogs Lander beagle'
        run('shash_values dogs').should == "retriever\nbeagle"
      end

      it 'can delete a key from a hash' do
        run 'shash_define dogs'
        run 'dogs Rover retriever'
        run 'dogs Lander "American Pitbull Terrier"'
        run 'dogs Murdock "Australian Shepherd"'
        run 'dogs "Long Name" "A kind of dog"'

        run('dogs_keys').should == "Rover\nLander\nMurdock\nLong Name"

        run 'shash_delete dogs Lander'
        run('dogs_keys').should == "Rover\nMurdock\nLong Name"

        run 'dogs_delete "Long Name"'
        run('dogs_keys').should == "Rover\nMurdock"

        run 'dogs_delete Rover'
        run('dogs_keys').should == "Murdock"
      end

      it 'can easily do something for each item (without having to manually make a for loop)' do
        run 'shash_define dogs'
        run 'dogs Rover retriever'
        run 'dogs Murdock "Australian Shepherd"'
      
        run(%{dogs_each 'echo "$key is a $value"'}).should == "Rover is a retriever\nMurdock is a Australian Shepherd"
      end

      it 'can easily print out something for each item' do
        run 'shash_define dogs'
        run 'dogs Rover retriever'
        run 'dogs Murdock "Australian Shepherd"'
      
        run(%{dogs_echo '$key is a $value'}).should == "Rover is a retriever\nMurdock is a Australian Shepherd"
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
          run('echo $__shash__dogs__Rover').should == ''
          run 'shash dogs Rover retriever'
          run('echo $__shash__dogs__Rover').should == 'retriever'
        end

      end
    end
  end

end
