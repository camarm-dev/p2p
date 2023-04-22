require 'thor'
require './lib/storage/utils'
require './cli/servers'

CONFIG = Storage::read('config')

class P2P < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"
  desc "P2P Cli", "The easiest way to push to production any application in one command !"

  desc "info", "Test your current p2p installation."
  long_desc <<-LONGDESC
    `p2p info` will print out informations about your current p2p installation.

    > $ p2p info
  LONGDESC
  def info
    puts "Installed path: #{__FILE__}"
    puts "Version: #{CONFIG["version"]}"
  end

  def Thor.exit_on_failure?
    puts "Fatal error ❌"
    exit 1
  end

  desc "servers", "P2p servers utilities"
  subcommand 'servers', Servers
end

P2P.start(ARGV)
