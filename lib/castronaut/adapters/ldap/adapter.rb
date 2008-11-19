 module Castronaut
  module Adapters
    module Ldap
      
      class Adapter < Castronaut::Adapters::Base
      
        def self.authenticate(username, password)
          Castronaut::Adapters::Ldap::User.authenticate(username, password)
        end
      
      end
    
    end
  end
end
