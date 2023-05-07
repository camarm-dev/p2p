$VERBOSE = nil
require 'thor'
require '/usr/lib/p2p/lib/storage/utils'
require '/usr/lib/p2p/lib/eval/eval'
require '/usr/lib/p2p/cli/servers'

CONFIG = Storage::read('config')

class P2P < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v"
  desc "P2P Cli", "The easiest way to push to production any application in one command !"

  map %w[--exec -e --push -p] => :exec
  desc "--exec, -e, --push, -p", "Execute the .p2p file in the current directory."
  long_desc <<-LONGDESC
    `p2p` will execute the p2p program that is written in the .p2p file.

    > $ p2p
  LONGDESC
  option :file, :default => ".p2p"
  def exec
    Program.run(options[:file])
    current_directory = `pwd`.tr("\n", "")
    puts "\e[2m#{current_directory} - p2p #{CONFIG["version"]}\e[0m"
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

  desc "update", "Update your current p2p installation."
  long_desc <<-LONGDESC
    `p2p update` will try to download the lastest p2p version.

    > $ p2p update
  LONGDESC
  def update
    puts "Running installation command..."
    `curl https://raw.githubusercontent.com/camarm-dev/p2p/main/install.sh | sudo sh`
    puts "P2P successfully updated ! Execute p2p info to see installed version"
  end

  def Thor.exit_on_failure?
    puts "\e[31mFatal error ❌\e[0m"
    exit 1
  end

  desc "servers", "P2p servers utilities"
  subcommand 'servers', Servers
end

P2P.start(ARGV)
