module Castronaut
  module Presenters

    class Logout < Base
      def url
        params['url']
      end

      def ticket_granting_ticket_cookie
        cookies['tgt']
      end
      
      def login_ticket
        Castronaut::Models::LoginTicket.generate_from(client_host).ticket
      end

      def represent!
        ticket_granting_ticket = Castronaut::Models::TicketGrantingTicket.find_by_ticket(ticket_granting_ticket_cookie) 
        
        cookies.delete 'tgt'
        controller.delete_cookie('tgt')

        if ticket_granting_ticket
          Castronaut::Models::ProxyGrantingTicket.clean_up_proxy_granting_tickets_for(ticket_granting_ticket.identifier)
          ticket_granting_ticket.destroy
        end
        
        messages << "You have successfully logged out."
        
        @your_mission = { :template => :logout }
                
        self
      end
    
    end

  end
  
end

