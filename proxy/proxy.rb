require 'sinatra'
require 'json'
require 'elasticsearch'
require_relative 'proxy/price_manager'
require_relative 'proxy/decriptor'


set :bind, '0.0.0.0'
set :port, 4569


post '/magento_product/_search' do
  @json = JSON.parse(request.body.read)
  client = Elasticsearch::Client.new   host: '10.0.3.108', log: true
  response =client.search index: 'magento_product', size: @params[:size],  from: @params[:from], body: @json
  price_manager = PriceManager.new
  price_manager.get_simple_price response,@params['stats']
  response.to_json

end
