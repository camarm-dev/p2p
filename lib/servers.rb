require './lib/net/utils'
require './lib/storage/utils'
require './lib/ansi'
require 'net/ping'
require 'io/console'

class P2PServersUtilities
    @@max_key_len = 16

    def add_wizard
        print "Enter server hostname (e.g 45.67.89.67, server.domain.com) >>> "
        hostname = $stdin.gets.tr("\n ", "")

        print "#{$CLEAR}Enter server ssh port (provide 22 if you don't know) >>> "
        port = $stdin.gets.tr("\n ", "")

        print "#{$CLEAR}Enter user for distant server (e.g user, root) >>> "
        user = $stdin.gets.tr("\n ", "")

        print "#{$CLEAR}Copy keys (don't type the password at each connection) (y/n) >>> "
        copy = $stdin.gets.tr("\n ", "")

        print "#{$CLEAR}Enter wanted server name, max 16 chars (e.g website-prod) >>> "
        name = $stdin.gets.tr("\n ", "")

        while name.length > @@max_key_len
            print "#{$CLEAR}Enter wanted server name, max 16 chars (e.g website-prod) >>> "
            name = $stdin.gets.tr("\n ", "")
        end

        if copy.downcase == "y"
            puts "#{$CLEAR}Copying keys, your password will be asked:"
            success = system("ssh-copy-id -p #{port} #{user}@#{hostname}")
            if success == false || success == nil
                puts "#{$RED}Host cannot be accessible thru ssh. Please make sure a ssh server is running on #{user}@#{hostname} ❌#{$RESET}"
                exit(-1)
            else
                puts "Trying to login without password..."
                host = P2PNet::Host.new(user, hostname, port)
                unless host.test
                    puts "#{$CLEAR}#{$RED}Failed, please make sure you provided the correct values. ❌#{$RESET}"
                    exit
                end
            end
        else
            puts "#{$CLEAR}To verify if distant host is ready, please enter your password."
            host = P2PNet::Host.new(user, hostname, port, password=true)
            unless host.test
                puts "#{$CLEAR}#{$RED}Failed, please make sure you provided the correct values. ❌#{$RESET}"
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
        puts "#{$CLEAR}#{$CLEAR}#{$CLEAR}#{$CLEAR}#{$CLEAR}#{$CLEAR}#{$GREEN}Server successfully added. ✅#{$RESET}"
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

    def self.get(name)
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

    def save_to_p2p(name)
        server = P2PServersUtilities.get(name)
        if server == nil
            puts "\n#{$RED}P2P server '#{name}' not found ❌#{$RESET}"
            return
        end
        puts "Connecting to #{name}... Type \"close\" to exit and \"abort\" to abort."
        host = P2PNet::Host.new(server['user'], server['hostname'], server['port'], server['require_password'])
        commands = ["DIST #{name}"]
        context, _ = host.call('pwd')[0].tr("\n", "")
        while true
            user, _ = host.call('whoami')[0].tr("\n", "")
            print "#{$GREEN}#{user}@#{server['hostname']}#{$RESET}:\e[34m#{context} $#{$RESET} "
            command = $stdin.gets.tr("\n", "")
            if command == 'close'
                break
            elsif command == 'abort'
                puts "\n#{$RED}Aborted ❌#{$RESET}"
                puts "#{$GREY}server '#{name}' - p2p #{CONFIG["version"]}#{$RESET}"
            elsif command.start_with?('cd')
                arg = command.gsub('cd ', '')
                if arg.start_with?('/')
                    target = arg
                else
                    unless context.end_with?('/')
                        context += '/'
                    end
                    target = context + arg
                end
                context = target
                commands.push("CTX #{target}")
                puts "#{$GREY}\t-> Translating \"cd\" to \"CTX\"; moved to #{target}#{$RESET}"
            else
                commands.push("COMMAND #{command}")
                output, _ = host.call("cd #{context} && #{command}")[0].gsub("\n", "\n\t   ")
                puts "#{$GREY}\t-> #{output}#{$RESET}"
            end
        end
        commands.push("# Generated by p2p init\n")
        File.write('.p2p', commands.join("\n"))
        puts "\n#{$GREEN}.p2p file successfully generated ✅#{$RESET}"
        puts "#{$GREY}server '#{name}' - p2p #{CONFIG["version"]}#{$RESET}"
    end
end
