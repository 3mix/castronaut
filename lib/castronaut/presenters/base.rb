module Castronaut
  module Presenters
    class Base
      attr_reader :controller, :your_mission, :ticket_granting_ticket
      attr_accessor :messages
      
      delegate :params, :request, :to => :controller
      delegate :cookies, :env, :to => :request

      def initialize(controller)
        @controller = controller
        @messages = []
      end
      
      def service
        params['service']
      end

      def renewal
        params['renew']
      end
      
      def ticket
        params['ticket']
      end
      
      def client_host
        env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_HOST'] || env['REMOTE_ADDR']
      end
    end
  end
end
