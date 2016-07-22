require 'redis'
require 'rest-client'

client = Redis.new(:host => "redis")
keys = client.keys('*critical/index*')
keys.each do |k|
  p k
  client.del k
end
