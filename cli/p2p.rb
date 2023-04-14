require 'thor'
require './lib/storage/utils'
require './cli/servers'

CONFIG = Storage::read('config')

class P2P < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"
  desc "P2P Cli", "The easiest way to push to production any application in one command !"

  desc "info", "Test your current p2p installation."
  def info
    puts "Installed path: #{__FILE__}"
    puts "Version: #{CONFIG["version"]}"
  end

  desc "servers", "P2p servers utilities"
  subcommand 'servers', Servers
end

P2P.start(ARGV)
