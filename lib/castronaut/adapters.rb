module Castronaut
  module Adapters
    
    def self.selected_adapter
      adapter_name = Castronaut.config.cas_adapter['adapter']
      %w{adapter user}.each do |type|
        require File.join('castronaut', 'adapters', adapter_name, type)
      end
      "Castronaut::Adapters::#{adapter_name.classify}::Adapter".constantize
    end
    
  end
end
