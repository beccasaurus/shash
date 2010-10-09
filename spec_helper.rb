require 'rubygems'
require 'bundler/setup'
Bundler.require

module HelperMethods
  def reset_session! shell_class = Session::Sh
    @shell = shell_class.new
    @shell.execute ". #{File.dirname(__FILE__)}/shash.sh"
  end

  def run cmd
    stdout, stderr = @shell.execute "#{cmd} 2>&1" # redirect all stderr to stdout
    stdout.to_s.chomp
  end

  def result cmd = nil
    run cmd if cmd
  end

  def echo cmd
    run "echo #{cmd}"
  end
end
