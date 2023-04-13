require 'net/ssh'
require 'net/ping'
require 'io/console'

class P2PServersUtilities

    def add_wizard
        print "Enter server hostname (e.g 45.67.89.67 or server.domain.com) >>> "
        hostname = $stdin.gets

        print "Enter server ssh port (provide 22 if you don't know) >>> "
        port = $stdin.gets

        print "Enter user for distant server (e.g user or root) >>> "
        user = $stdin.gets

        print "Copy keys (don't type the password at each connection) (y/n) >>> "
        copy = $stdin.gets
        
        print "Enter wanted server name (e.g website-prod) >>> "
        name = $stdin.gets
        
        puts "Processing a connection test to the fresh p2p server"
        
        host = Net::Ping::External.new(hostname)

        if host.ping
            puts "Host reachable ✅"
        else
            puts "Host unreachable ❌"
            exit(-1)
        end

        if copy.lower == "y"
            puts "Copying keys, your password will be asked:"
            success = system("ssh-copy-id %d@%d -p %d" % [user, hostname, port])
            if success in [false, nil]
                puts "Host cannot be accessible thru ssh. Please make sure a ssh server is running on %d%d ❌"% [user, hostname]
                exit(-1)
            else
            puts "Try to login without password"
            Net::SSH.start(hostname, user, port: port) do |ssh|
                username = ssh.exec!("whoami")
                puts "Host can be accessible has %d thru ssh ✅" % [username]
                end
            end
        else
            puts "To verify if distant host is ready, please enter your password."
            password = IO::console.getpass "Enter %d@%d: " % [user, hostname]

            Net::SSH.start(hostname, user, password: password, port: port) do |ssh|
                username = ssh.exec!("whoami")
                puts "Host can be accessible has %d thru ssh ✅" % [username]
            end
        end
    end
end
