require 'rubygems'
require 'bundler/setup'
Bundler.require
require 'open3'

module HelperMethods
  def reset_session! shell = '/bin/sh'
    @stdin, @stdout, @stderr = Open3.popen3(shell)
    run ". #{File.dirname(__FILE__)}/shash.sh"
  end

  def run cmd
    @stdin.puts cmd
  end

  def result cmd = nil
    run cmd if cmd
    @stdout.gets.chomp
  end

  def echo cmd
    run "echo #{cmd}"
    result
  end
end
