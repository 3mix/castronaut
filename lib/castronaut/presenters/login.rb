module Castronaut
  module Presenters

    class Login < Base
      def gateway?
        return true if params['gateway'] == 'true'
        return true if params['gateway'] == '1'
        false
      end

      def ticket_generating_ticket_cookie
        cookies['tgt']
      end

      def redirection_loop?
        params.has_key?('redirection_loop_intercepted')
      end
      
      def login_ticket
        Castronaut::Models::LoginTicket.generate_from(client_host).ticket
      end

      def represent!
        ticket_granting_ticket_result = Castronaut::Models::TicketGrantingTicket.validate_cookie(ticket_generating_ticket_cookie)

        if ticket_granting_ticket_result.valid?
          messages << "You are currently logged in as #{ticket_granting_ticket_result.identifier}.  If this is not you, please log in below."
        end

        if redirection_loop?
          messages << "The client and server are unable to negotiate authentication.  Please try logging in again later."
        else

          if service
            if !renewal && ticket_granting_ticket_result.valid?
              service_ticket = Castronaut::Models::ServiceTicket.generate_ticket_for(service, client_host, ticket_granting_ticket_result.ticket)
            
              if service_ticket.service_uri
                @your_mission = { :redirect => service_ticket.service_uri, :status => 303 }
              else
                messages << "The target service your browser supplied appears to be invalid. Please contact your system administrator for help."
              end            
            end
          elsif gateway?
            messages << "The server cannot fulfill this gateway request because no service parameter was given."
          end
          
        end
        
        @your_mission = { :template => :login }
                
        self
      end
    
    end

  end
  
end

