module Castronaut
  module Presenters

    class ProxyValidate < Base
      MissingCredentialsMessage = "Please supply a username and password to login."

      attr_reader :proxy_ticket_result, :proxies
      attr_accessor :login_ticket

      def proxy_granting_ticket_url
        params['pgtUrl']
      end

      def proxy_granting_ticket_iou
        @proxy_granting_ticket_result && @proxy_granting_ticket_result.iou
      end

      def username
        @proxy_ticket_result.username
      end
      
      def identifier
        @proxy_ticket_result.identifier
      end
      def extra_xml
        @proxy_ticket_result.extra_xml
      end

      def represent!
        @proxy_ticket_result = Castronaut::Models::ProxyTicket.validate_ticket(service, ticket)

        if @proxy_ticket_result.valid?
          @proxies = @proxy_ticket_result.proxies

          if proxy_granting_ticket_url
            @proxy_granting_ticket_result = Castronaut::Models::ProxyGrantingTicket.generate_ticket(proxy_granting_ticket_url, client_host, @proxy_ticket_result.ticket)
          end
        end

        @your_mission = { :template => :proxy_validate, :layout => false }

        self
      end

    end

  end
end

