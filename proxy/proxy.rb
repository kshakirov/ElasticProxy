require "rack/cache"
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


before do
  headers 'Connection' => 'permanent'
end

def set_critical_cache cache_time=3600, expires_time=3600
  content_type 'application/json'
  cache_control :public, :max_age => cache_time
  expires expires_time, :public
end


post '/magento_product/_search' do
  @json = JSON.parse(request.body.read)
  response =settings.client.search index: 'magento_product', size: @params[:size],  from: @params[:from], body: @json
  price_manager = PriceManager.new
  price_manager.get_simple_price response,@params['stats']
  response.to_json

end


get '/critical/index/sorters' do
  set_critical_cache
  uri = "/critical/index/sorters?part_type=" + params[:part_type]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end

get '/critical/index/headers' do
  set_critical_cache
  uri = "/critical/index/headers?part_type=" + params[:part_type]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end


get '/critical/index/filters' do
  set_critical_cache
  uri = "/critical/index/filters?part_type=" + params[:part_type]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end

get '/critical/index/partssorters' do
  set_critical_cache
  uri = "/critical/index/partssorters?part_type=" + params[:part_type]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end

get '/critical/index/partsfilters' do
  set_critical_cache
  uri = "/critical/index/partsfilters?part_type=" + params[:part_type]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end

get '/critical/index/partsheaders' do
  set_critical_cache
  uri = "/critical/index/partsheaders?part_type=" + params[:part_type]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end

get '/critical/index/manufacturersfilters' do
  set_critical_cache
  uri = "/critical/index/manufacturersfilters?part_type=" + params[:part_type] + '&manufacturer=' + params[:manufacturer]
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end


get '/critical/index/catalogfilters' do
  set_critical_cache
  uri = "/critical/index/catalogfilters"
  response, timestamp =settings.magento_proxy.create_cached_response uri, settings.redis_client, settings.host
  response
end

get '/critical/index/featuredProducts' do
  set_critical_cache 900, 900
  uri = "/critical/index/featuredProducts?stats=" + params[:stats]
  response, timestamp = settings.magento_proxy.create_cached_response(uri, settings.redis_client, settings.host, 900)
  last_modified(timestamp)
  response
end

get '/critical/index/newProducts' do
  set_critical_cache 900, 900
  uri = "/critical/index/newProducts?stats=" + params[:stats]
  response, timestamp = settings.magento_proxy.create_cached_response(uri, settings.redis_client, settings.host, 900)
  last_modified(timestamp)
  response
end


if ENV['MAGENTO_HOST'].nil?
  puts 'Set MAGENTO_HOST env variable, which must point to Magento Host'
  exit(1)
end