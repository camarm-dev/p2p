$VERBOSE = nil
require 'thor'
require '/usr/lib/p2p/lib/storage/utils'
require '/usr/lib/p2p/lib/eval/eval'
require '/usr/lib/p2p/lib/servers'
require '/usr/lib/p2p/cli/servers'
require '/usr/lib/p2p/lib/ansi'
require 'uri'
require 'net/http'

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
    puts "#{$GREY}#{current_directory} - p2p #{CONFIG["version"]}#{$RESET}"
  end

  map %w[version -v --version] => :info
  desc "info", "Test your current p2p installation."
  long_desc <<-LONGDESC
    `p2p info` will print out informations about your current p2p installation.

    > $ p2p info
  LONGDESC
  def info
    puts "Installed path: #{__FILE__}"
    puts "Version: #{CONFIG["version"]}"
    puts "Changelog: #{CONFIG['changelog']}}"
  end

  desc "update", "Update your current p2p installation."
  long_desc <<-LONGDESC
    `p2p update` will try to download the latest (or the given) p2p version, (run this as root or don't forget to type your password when asked !).

    > $ p2p update
  LONGDESC
  option :version, :default => "latest"
  def update
    version = options[:version]
    puts "#{$BOLD}Searching for version #{version} 🔍...#{$RESET}"

    if version != "latest"
      release = Net::HTTP.get_response(URI("https://api.github.com/repos/camarm-dev/p2p/releases/tags/v#{version}"))
      unless release.is_a?(Net::HTTPSuccess)
        puts "#{$CLEAR}#{$RED}Searching for version #{version} 🔍✖️#{$RESET}"
        abort
      end
      release = JSON.parse(release.body)
    else
      release = JSON.parse(Net::HTTP.get_response(URI("https://api.github.com/repos/camarm-dev/p2p/releases/latest")).body)
    end
    puts "#{$CLEAR}#{$GREEN}Searching for version #{version} 🔍✔️#{$RESET}"
    commit = release['target_commitish']
    puts "#{$YELLOW}-> Target commit #{$UNDERLINE}#{commit}#{$RESET}"
    puts "#{$YELLOW}-> Downloading gzip & install...#{$RESET}#{$GREY}"
    file_url = JSON.parse(Net::HTTP.get_response(URI("https://api.github.com/repos/camarm-dev/p2p/contents/packed/p2p-libs.tar.gz?ref=#{commit}")).body)['download_url']
    `curl #{file_url} -s -o libs.tar.gz && curl https://raw.githubusercontent.com/camarm-dev/p2p/main/config.default.json -s -o ~/.p2p/config.json && curl -s https://raw.githubusercontent.com/camarm-dev/p2p/main/install-tarball.sh | sudo sh`
    puts "#{$RESET}P2P successfully updated ! Execute p2p info to see installed version"
  end

  desc "init", "Connect to a server and save commands as a p2p deployment."
  long_desc <<-LONGDESC
    `p2p init` will try to download the latest p2p version.

    > $ p2p init --server <server-name>
  LONGDESC
  option :server, :default => nil
  def init
    server = options[:server]
    if server == nil
      puts "#{$RED}Please provide a server ❌#{$RESET}"
    end
    P2PServersUtilities.new().save_to_p2p(server)
  end

  def Thor.exit_on_failure?
    puts "#{$RED}Fatal error ❌#{$RESET}"
    exit 1
  end

  desc "servers", "P2p servers utilities"
  subcommand 'servers', Servers
end

P2P.start(ARGV)
