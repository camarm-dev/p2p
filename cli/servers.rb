require 'thor'
require './lib/servers'
require './lib/net/utils'

SERVERS = P2PServersUtilities.new()

class Servers < Thor
  class_option :verbose, :type => :boolean, :aliases => "-v", :default => false
  @@max_key_len = 16
  
  desc "add", "Add a distant host to p2p servers."
  long_desc <<-LONGDESC
    `p2p servers add` will ask you question thru  quick wizard to add a server to the p2p registered servers.

    > $ p2p servers add
  LONGDESC
  def add
    puts "\e[1m\e[4mComplete the following wizard to add a p2p server:\e[0m"
    SERVERS.add_wizard
  end
  
  desc "list", "List registered p2p servers"
  long_desc <<-LONGDESC
    `p2p servers list` will print out every p2p registered servers.

    > $ p2p servers list
  LONGDESC
  def list
    servers = SERVERS.list

    puts "\e[1mRegistered servers:\e[0m"

    servers.each do |server|
      space = ' ' * (@@max_key_len - server['name'].length)
      puts "#{server['name']}#{space}-\t#{server['user']}@#{server['hostname']}"
    end

    puts "\e[2m#{servers.length} servers - p2p #{CONFIG["version"]}\e[0m"

  end

  desc "remove [server-name]", "Remove a p2p server."
  long_desc <<-LONGDESC
    `p2p servers remove [server-name]` will remove [server-name] from p2p registered servers.

    > $ p2p servers remove [server-name]
  LONGDESC
  def remove(name)
    server = SERVERS.remove(name)

    if server == nil
      puts "\e[31mCannot find server '#{name}' ❌\e[0m"
      exit
    end

    puts "\e[32mServer successfully deleted ✅\e[0m"

    puts "\e[2mserver '#{name}' - p2p #{CONFIG["version"]}\e[0m"
  end

  desc "spec [server-name]", "Get a p2p server spec."
  long_desc <<-LONGDESC
    `p2p servers spec [server-name]` will show [server-name] specs.

    > $ p2p servers spec [server-name]
  LONGDESC
  def spec(name)
    server = SERVERS.get(name)

    puts "\e[1mSpecs of '#{name}':\e[0m"

    if server == nil
      puts "\e[31mCannot find server '#{name}' ❌\e[0m"
      exit
    end

    server.keys.each do |key|
      puts "#{key}:  #{' ' * (@@max_key_len - key.length)}#{server[key]}"
    end

    puts "\e[2mserver '#{name}' - p2p #{CONFIG["version"]}\e[0m"
  end
  
  desc "test [server-name]", "Test a p2p server connectivity."
  long_desc <<-LONGDESC
    `p2p servers test [server-name]` will test [server-name] ssh connectivity.

    > $ p2p servers test [server-name]
  LONGDESC
  def test(name)
    server = SERVERS.get(name)

    puts "\e[1mTesting '#{name}':\e[0m"

    if server == nil
      puts "\e[31mCannot find server '#{name}' ❌\e[0m"
      exit
    end

    begin
      host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
      if host.test
        puts "\e[32mServer '#{name}' has been tested successfully. ✅\e[0m"
      end
    rescue
      puts "\e[31mFailed to connect to the server '#{name}' ❌\e[0m"
    end


    puts "\e[2mserver '#{name}' - p2p #{CONFIG["version"]}\e[0m"
  end
end
