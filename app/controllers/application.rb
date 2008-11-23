def presents(klass, template_type=Castronaut.config.template_type)
  @presenter = klass.new(self)
  @presenter.represent!
  if @presenter.your_mission[:redirect]
    redirect @presenter.your_mission[:redirect], @presenter.your_mission[:status]
  elsif @presenter.your_mission[:template]
    send template_type, @presenter.your_mission[:template]
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
