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

  def run(cmd) puts cmd; @stdin.puts(cmd) end

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

end
