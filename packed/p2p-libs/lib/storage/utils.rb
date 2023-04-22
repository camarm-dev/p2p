require 'json'

module Storage
    FOLDER = "#{Dir.home}/.p2p"

    def self.default_file(name)
        path = "#{FOLDER}/#{name}.json"
        unless File.exist?(path)
            File.new(path, "w")
            data = {
              "data" => []
            }
            File.write("#{FOLDER}/#{name}.json", JSON.dump(data))
        end
    end

    def self.write(data, name)
        (name)
        File.write("#{FOLDER}/#{name}.json", JSON.dump(data))
    end

    def self.read(name)
        default_file(name)
        return JSON.parse(File.read("#{FOLDER}/#{name}.json"))
    end

    private_class_method :default_file
end
