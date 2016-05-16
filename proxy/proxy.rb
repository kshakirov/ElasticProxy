require 'sinatra'
require 'json'
require 'elasticsearch'


#set :bind, '0.0.0.0'
set :port, 4569


post '*' do
  @json = JSON.parse(request.body.read)
  client = Elasticsearch::Client.new   host: 'localhost', log: true
  p @params


  response =client.search index: 'magento_product', type: 'product', size: @params[:size],  from: @params[:from], body: @json
  response.to_json

end