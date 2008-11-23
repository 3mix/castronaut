module Castronaut
  module Presenters

    class ServiceValidate < Base
      MissingCredentialsMessage = "Please supply a username and password to login."

      attr_reader :service_ticket_result
      attr_accessor :login_ticket

      def proxy_granting_ticket_url
        params['pgtUrl']
      end

      def proxy_granting_ticket_iou
        @proxy_granting_ticket_result && @proxy_granting_ticket_result.iou
      end

      def identifier
        @service_ticket_result.identifier
      end

      def extra_xml
        @service_ticket_result.extra_xml
      end

      def represent!
        @service_ticket_result = Castronaut::Models::ServiceTicket.validate_ticket(service, ticket)

        if @service_ticket_result.valid?
          if proxy_granting_ticket_url
            @proxy_granting_ticket_result = Castronaut::Models::ProxyGrantingTicket.generate_ticket(proxy_granting_ticket_url, client_host, @service_ticket_result.ticket)
          end
        end

        @your_mission = { :template => :service_validate, :layout => false }

        self
      end

    end

  end
end
