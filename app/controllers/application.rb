if (initializers = Castronaut.config.initializers) && !initializers.empty?
  initializers.each { |i| load i }
end

def presents(klass, template_type=Castronaut.config.template_type)
  @page_title ||= 'Sign In'
  @presenter = klass.new(self)
  @presenter.represent!
  mission = @presenter.your_mission
  if mission[:redirect]
    redirect mission[:redirect], mission[:status]
  elsif mission[:template]
    send template_type, mission[:template], :layout => mission[:layout].nil? ? :layout : mission[:layout]
  end
end

get '/' do
  redirect '/login'
end

get '/login' do
  no_cache
  presents Castronaut::Presenters::Login
end

post '/login' do
  presents Castronaut::Presenters::ProcessLogin
end

get '/logout' do
  presents Castronaut::Presenters::Logout
end

get '/serviceValidate' do
  presents Castronaut::Presenters::ServiceValidate, :erb
end

get '/proxyValidate' do
  presents Castronaut::Presenters::ProxyValidate, :erb
end

private
  def no_cache
    headers 'Pragma' => 'no-cache',
    'Cache-Control' => 'no-store',
    'Expires' => (Time.now - 5.years).rfc2822
  end
