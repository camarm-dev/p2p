require 'net/ssh'
require 'net/ping'

module P2PNet
    class Host
        
        def initialize(user, host, port, password=false)
            @user = user
            @host = host
            @port = port
            @required_password = password
            if password
                @password = IO::console.getpass "%d@%d password: " % [user, hostname]
            end
        end

        def test
            if Net::Ping::External.new(hostname).ping
                if @required_password
                    Net::SSH.start(@user, @host, port: @port, password: @password) do |ssh| 
                        ssh.exec!("whoami")
                    end
                else
                    Net::SSH.start(@user, @host, port: @port) do |ssh| 
                        ssh.exec!("whoami")
                    end
                end
                return true
            end
        end

        def exec(commands=[])
            if @required_password
                ssh = Net::SSH.start(@user, @host, port: @port, password: @password)
            else
                ssh = Net::SSH.start(@user, @host, port: @port)
            commands.each do command 
                ssh.exec!(command)
            end
        end
    end
end
