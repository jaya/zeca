require 'sinatra'
require 'mailgun'
require 'erb'

configure do
  set :server, :puma
end

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = ENV['ALLOWED_DOMAIN']
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
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

options '*' do
  response.headers['Allow'] = 'HEAD,GET,PUT,DELETE,OPTIONS,POST'
  response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept'
  200
end
