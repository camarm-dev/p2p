$VERBOSE = nil
require 'thor'
require './lib/storage/utils'
require './lib/eval/eval'
require './cli/servers'

CONFIG = Storage::read('config')

class P2P < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"
  desc "P2P Cli", "The easiest way to push to production any application in one command !"

  map %w[--exec -e] => :exec
  desc "--exec, -e", "Execute the .p2p file in the current directory."
  long_desc <<-LONGDESC
    `p2p` will execute the p2p program that is written in the .p2p file.

    > $ p2p
  LONGDESC
  option :file, :default => ".p2p"
  def exec
    Program.run(options[:file])
  end

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
