module Castronaut

  class AuthenticationResult
    
    attr_reader :username, :identifier, :error_message, :extra_info
        
    def initialize(username, error_message=nil, options={})
      @username = username
      identifier = options[:identifier]
      @identifier = identifier.nil? ? username : identifier
      @extra_info = options[:extra_info]
      @error_message = error_message
      Castronaut.logger.info("#{self.class} - #{@error_message} for #{@username}") if @error_message && @username
    end
    
    def valid?
      error_message.nil?
    end
    
    def invalid?
      !valid?
    end
    
  end

end

