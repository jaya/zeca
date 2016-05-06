require 'sinatra'
require 'sinatra/cross_origin'
require 'mailgun'
require 'erb'

configure do
  set :server, :puma

  enable :cross_origin
  set :allow_origin, ENV['ALLOWED_DOMAIN']
  set :allow_methods, [:post]
end


helpers do
  def template_file(template_name)
    File.read(File.join('templates', "#{template_name}.erb"))
  end
end

post '/contact' do
  client = Mailgun::Client.new(ENV['MAILGUN_API_TOKEN'])
  renderer = ERB.new(template_file('contact'))

  message_params = {
    from: "#{params[:name]} <#{params[:email]}>",
    to: ENV['MAINGUN_RECEIVER'],
    subject: 'Jaya - Contact through site',
    html: renderer.result(binding)
  }

  client.send_message(ENV['MAINGUN_DOMAIN'], message_params)
end

post '/subscribe' do
  client = Mailgun::Client.new(ENV['MAILGUN_API_TOKEN'])
  client.post("lists/#{ENV['MAILGUN_MAILING_LIST']}/members", { address: params[:address], vars: '{}' })
end

options "*" do
  response.headers['Allow'] = 'POST'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end
