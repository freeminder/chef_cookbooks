require 'json'

module Helpers
  module DockerTest
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def container_exists?(image, command = nil)
      dps = shell_out('docker ps -a --no-trunc')
      return dps.stdout.include?(command) if command
      dps.stdout.include?(image)
    end

    def container_running?(image, command = nil)
      dps = shell_out('docker ps -a --no-trunc')
      dps.stdout.each_line do |dps_line|
        if command
          return dps_line.include?('Up') if dps_line.include?(command)
        else
          return dps_line.include?('Up') if dps_line.include?(image)
        end
      end
      false
    end

    def image_exists?(image)
      di = shell_out('docker images -a')
      di.stdout.include?(image)
    end

    def container_info(name)
      JSON.parse(shell_out("docker inspect #{name}").stdout)
    end
  end
end
