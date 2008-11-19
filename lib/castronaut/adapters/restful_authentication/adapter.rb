require 'castronaut/adapters/active_record_adapter'

module Castronaut
  module Adapters
    module RestfulAuthentication
      
      class Adapter < Castronaut::Adapters::Base
        
        def self.user_class
          Castronaut::Adapters::RestfulAuthentication::User
        end
      
        def self.authenticate(username, password)
          self.user_class.authenticate(username, password)
        end
      
      end
    
    end
  end
end
