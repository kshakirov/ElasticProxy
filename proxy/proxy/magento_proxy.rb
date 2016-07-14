class MagentoProxy
  def create_cached_response uri, redis_client, host
    response = redis_client.get(uri)
    if response
      response
    else
      response = RestClient.get(host + uri)
      redis_client.set(uri, response)
      response
    end
  end
end