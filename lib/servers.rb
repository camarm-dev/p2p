require './lib/net/utils'
require './lib/storage/utils'
require 'net/ping'
require 'io/console'

class P2PServersUtilities
    @@max_key_len = 16

    def add_wizard
        print "Enter server hostname (e.g 45.67.89.67, server.domain.com) >>> "
        hostname = $stdin.gets.tr("\n ", "")

        print "\e[A\e[KEnter server ssh port (provide 22 if you don't know) >>> "
        port = $stdin.gets.tr("\n ", "")

        print "\e[A\e[KEnter user for distant server (e.g user, root) >>> "
        user = $stdin.gets.tr("\n ", "")

        print "\e[A\e[KCopy keys (don't type the password at each connection) (y/n) >>> "
        copy = $stdin.gets.tr("\n ", "")

        print "\e[A\e[KEnter wanted server name, max 16 chars (e.g website-prod) >>> "
        name = $stdin.gets.tr("\n ", "")

        while name.length > @@max_key_len
            print "\e[A\e[KEnter wanted server name, max 16 chars (e.g website-prod) >>> "
            name = $stdin.gets.tr("\n ", "")
        end

        if copy.downcase == "y"
            puts "\e[A\e[KCopying keys, your password will be asked:"
            success = system("ssh-copy-id -p #{port} #{user}@#{hostname}")
            if success == false || success == nil
                puts "\e[31mHost cannot be accessible thru ssh. Please make sure a ssh server is running on #{user}@#{hostname} ❌\e[0m"
                exit(-1)
            else
                puts "Trying to login without password..."
                host = P2PNet::Host.new(user, hostname, port)
                unless host.test
                    puts "\e[A\e[K\e[31mFailed, please make sure you provided the correct values. ❌\e[0m"
                    exit
                end
            end
        else
            puts "\e[A\e[KTo verify if distant host is ready, please enter your password."
            host = P2PNet::Host.new(user, hostname, port, password=true)
            unless host.test
                puts "\e[A\e[K\e[31mFailed, please make sure you provided the correct values. ❌\e[0m"
                exit
            end
        end

        servers = Storage.read("servers")

        servers['data'] << {
          "hostname" => hostname,
          "user" => user,
          "port" => port,
          "require_password" => copy.downcase != "y",
          "name" => name
        }

        Storage.write(servers, "servers")
        puts "\e[A\e[K\e[A\e[K\e[A\e[K\e[A\e[K\e[A\e[K\e[A\e[K\e[32mServer successfully added. ✅\e[0m"
    end

    def list
        return Storage.read("servers")['data']
    end

    def get(name)
        servers = Storage.read("servers")['data']
        servers.each do |server|
            if server['name'] == name
                return server
            end
        end
        return nil
    end

    def remove(name)
        servers = Storage.read("servers")
        servers['data'].each do |server|
            if server['name'] == name
                index = servers['data'].find_index(server)
                servers['data'].delete_at(index)
                Storage.write(servers, "servers")
                return server
            end
        end
        return nil
    end
end
