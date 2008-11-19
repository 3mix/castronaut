# Abstract base class for an ActiveRecord adapter

module Castronaut::Adapters
  class ActiveRecordAdapter < Base
  
    # You must provide user_class.
    
    def self.configure options
      self.user_class.establish_connection(options['database'])
      self.user_class.logger = options['logger']
      
      unless ENV["test"] == "true"
        if self.user_class.connection.tables.empty?
          STDERR.puts "#{self.class} - There are no tables in the given database.\nConfig details:\n#{options.inspect}"
          Kernel.exit(0)
        end
      end
    end
  end
end