require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'open3'

describe 'shash' do

  before { reset_session! }

  def reset_session!
    @stdin, @stdout, @stderr = Open3.popen3('/bin/sh')
    run ". #{File.dirname(__FILE__)}/shash.sh"
  end

  def run(cmd) @stdin.puts(cmd) end

  def result() @stdout.gets.chomp end

  it 'should be able to test a /bin/sh session' do
    run %{echo $foo}
    result.should == ''

    run %{foo=bar}
    run %{echo $foo}
    result.should == 'bar'

    reset_session!

    run %{echo $foo}
    result.should == ''
  end

  it 'should be able to set/get keys from a hash manually' do
    run %{shash dogs Rover retriever}
    run %{shash dogs Snoopy beagle}

    run %{shash dogs Rover}
    result.should == 'retriever'

    run %{shash dogs Snoopy}
    result.should == 'beagle'
  end

  it 'should be able to dynamically create a helper function to set/get keys from a particular hash' do
    run %{shash_define dogs}
    run %{dogs Lander "American Pitbull Terrier"}
    run %{dogs Lander}
    result.should == 'American Pitbull Terrier'

    run %{dogs Murdock}
    result.should == ''

    run %{dogs Murdock "Australian Shepherd"}
    run %{dogs Murdock}
    result.should == 'Australian Shepherd'
  end

  # Methods of persistance (ideas) ...
  #
  #  - dynamically named variables, 1 for each key
  #  - dynamically named variables, 1 for each hash
  #  - a file
  #  - a BASH associative array
  #  - a zsh associative array
  it 'should be able to configure the method of persistance shash uses (?)'

end
