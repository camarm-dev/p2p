require 'thor'
require './cli/servers'

class P2P < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"
  desc "P2P Cli", "The easiest way to push to production any application in one command !"

  desc "info", "Test your current p2p installation."
  def info
    puts "Installed path: %s" % __FILE__
    puts "Version: %s" % ["0.0.0"]
  end

  desc "servers", "P2p servers utilities"
  subcommand 'servers', Servers
end

P2P.start(ARGV)
