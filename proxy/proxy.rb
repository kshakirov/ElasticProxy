require 'sinatra'
require 'json'
require 'elasticsearch'
require 'redis'
require 'rest-client'
require_relative 'proxy/price_manager'
require_relative 'proxy/decriptor'
require_relative 'proxy/magento_proxy'


configure do
  set :client, Elasticsearch::Client.new(host: 'elastic-instance', log: true)
  set :redis_client, Redis.new(:host => "redis")
  set :magento_proxy, MagentoProxy.new
  set :host, ENV['MAGENTO_HOST']
end

set :bind, '0.0.0.0'
set :port, 4569


post '/magento_product/_search' do
  @json = JSON.parse(request.body.read)
  response =settings.client.search index: 'magento_product', size: @params[:size],  from: @params[:from], body: @json
  price_manager = PriceManager.new
  price_manager.get_simple_price response,@params['stats']
  response.to_json

end

get '/test' do
  puts "it is test"
end

get '/critical/index/sorters' do
  uri = "/critical/index/sorters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/headers' do
  uri = "/critical/index/headers?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end


get '/critical/index/filters' do
  uri = "/critical/index/filters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/partssorters' do
  uri = "/critical/index/partssorters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/partsfilters' do
  uri = "/critical/index/partsfilters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/partsheaders' do
  uri = "/critical/index/partsheaders?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end