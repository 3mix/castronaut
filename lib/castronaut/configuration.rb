require 'yaml'
require 'logger'
require 'fileutils'

class Hodel3000CompliantLogger < Logger
  def format_message(severity, timestamp, msg, progname)
    "#{timestamp.strftime("%b %d %H:%M:%S")} [#{$PID}]: #{severity} - #{progname.gsub(/\n/, '').lstrip}\n"
  end
end

module Castronaut

  class Configuration
    DefaultConfigFilePath = './castronaut.yml'

    attr_accessor :config_file_path, :config_hash, :logger

    def self.load(config_file_path = Castronaut::Configuration::DefaultConfigFilePath)
      config = Castronaut::Configuration.new
      config.config_file_path = config_file_path
      config.config_hash = parse_yaml_config(config_file_path)
      config.parse_config_into_settings(config.config_hash)
      config.logger = config.setup_logger
      config.debug_initialize if config.logger.debug?
      config.connect_activerecord
      config.configure_adapter
      config
    end

    def self.parse_yaml_config(file_path)
      YAML::load_file(file_path)
    end

    def parse_config_into_settings(config)
      mod = Module.new do
        config.each_pair do |k,v|
          if self.methods.include?(k.to_s)
            STDERR.puts "#{self.class} - Configuration tried to define #{k}, which was already defined." unless ENV["test"] == "true"
            next
          end
          define_method(k) { v }
        end
      end
      self.extend mod
    end

    def create_directory(dir)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end

    def setup_logger
      create_directory(log_directory)
      log = Hodel3000CompliantLogger.new("#{log_directory}/castronaut.log", "daily")
      log.level = eval(log_level)
      log
    end

    def debug_initialize
      logger.debug "#{self.class} - initializing with parameters"
      config_hash.each_pair do |key, value|
        logger.debug "--> #{key} = #{value.inspect}"
      end
      logger.debug "#{self.class} - initialization complete"
    end

    def can_fire_callbacks?
      config_hash.keys.include?('callbacks')
    end

    def connect_activerecord
      ActiveRecord::Base.logger = logger
      ActiveRecord::Base.colorize_logging = false

      connect_cas_to_activerecord
    end

    def connect_cas_to_activerecord
      logger.info "#{self.class} - Connecting to cas database using #{cas_database.inspect}"
      if cas_database['adapter'] == 'sqlite3'
        create_directory File.dirname(cas_database['database'])
      end
      ActiveRecord::Base.establish_connection(cas_database)

      migration_path = File.expand_path(File.join(File.dirname(__FILE__), 'db'))

      logger.debug "#{self.class} - Migrating to the latest version using migrations in #{migration_path}"
      ActiveRecord::Migrator.migrate(migration_path, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    end

    def configure_adapter
      Castronaut::Adapters.selected_adapter(cas_adapter['adapter']).configure({'logger' => logger}.merge(cas_adapter))
    end
  end

end
