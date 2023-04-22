require 'net/ssh'
require 'net/ping'

module P2PNet
    class Host
        
        def initialize(user, hostname, port, password=false)
            @user = user
            @host = hostname
            @port = port
            @required_password = password
            @conn = nil
            if password
                @password = IO::console.getpass "#{user}@#{hostname} password: "
            end
        end

        def test
            if Net::Ping::External.new(@host).ping
                if @required_password
                    Net::SSH.start(@host, @user, port: @port, password: @password) do |ssh| 
                        ssh.exec!("whoami")
                    end
                else
                    Net::SSH.start(@host, @user, port: @port) do |ssh| 
                        ssh.exec!("whoami")
                    end
                end
                return true
            end
        end

        def exec(commands=[])
            if @required_password
                ssh = Net::SSH.start(@host, @user, port: @port, password: @password)
            else
                ssh = Net::SSH.start(@host, @user, port: @port)
            end
            commands.each do |command|
                ssh.exec!(command)
            end
        end

        def upload(files=[], context='~')
            if @required_password
                ssh = Net::SSH.start(@host, @user, port: @port, password: @password)
            else
                ssh = Net::SSH.start(@host, @user, port: @port)
            end
            files.each do |file|
                filename = file.split('/')[-1]
                ssh.scp.upload(file, "#{context}/#{filename}")
            end
        end
    end
end
