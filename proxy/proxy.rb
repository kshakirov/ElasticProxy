require "rack/cache"
require 'sinatra'
require 'json'
require 'elasticsearch'
require 'redis'
require 'rest-client'
require_relative 'proxy/price_manager'
require_relative 'proxy/decriptor'
require_relative 'proxy/magento_proxy'

use Rack::Cache

configure do
  set :client, Elasticsearch::Client.new(host: 'elastic-instance', log: true)
  set :redis_client, Redis.new(:host => "redis")
  set :magento_proxy, MagentoProxy.new
  set :host, ENV['MAGENTO_HOST']
end

set :bind, '0.0.0.0'
set :port, 4569


before do
  headers 'Connection' => 'permanent'
end


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
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/sorters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/headers' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/headers?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end


get '/critical/index/filters' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/filters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/partssorters' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/partssorters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/partsfilters' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/partsfilters?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/partsheaders' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/partsheaders?part_type=" + params[:part_type]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end

get '/critical/index/manufacturersfilters' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/manufacturersfilters?part_type=" + params[:part_type] + '&manufacturer=' + params[:manufacturer]
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end


get '/critical/index/catalogfilters' do
  content_type 'application/json'
  cache_control :public, :max_age => 360000000
  expires 5000000000, :public
  uri = "/critical/index/catalogfilters"
  settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
end
