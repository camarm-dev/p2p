require 'thor'
require './cli/servers'

class P2P < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"

  desc "P2P Cli", "The easiest way to push to production any application in one command !"
  subcommand 'servers', Servers
end

P2P.start(ARGV)
