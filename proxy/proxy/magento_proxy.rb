class MagentoProxy

  def _set_timeout redis_client, uri, timeout
    modified = Time.now
    redis_client.expire uri, timeout
    redis_client.set(uri + '_timeout', modified.to_i)
    modified
  end

  def _get_timeout redis_client, uri
    timestamp = redis_client.get(uri + '_timeout')
    if timestamp
      Time.at(timestamp.to_i)
    else
      false
    end
  end

  def _get_modified_time redis_client, uri
    redis_client.get(uri + '_modified')
  end

  def _set_modified_time redis_client, uri
    modified = Time.now
    redis_client.set(uri + '_timeout', modified.to_i)
    modified
  end

  def _cache_response redis_client, host, uri, timeout
    response = RestClient.get(host + uri)
    redis_client.set(uri, response)
    if timeout
      return response, _set_timeout(redis_client, uri, timeout)
    else
      return response, false
    end
  end

  def create_cached_response uri, redis_client, host, timeout=false
    response = redis_client.get(uri)
    if response
      return response, _get_timeout(redis_client, uri)
    else
      _cache_response(redis_client, host, uri, timeout)
    end
  end

  def get_part_response uri, redis_client, host
    response = redis_client.get(uri)
    if response
      return response, _get_modified_time(redis_client, uri)
    else
      response, modified= _cache_response(redis_client, host, uri, false)
      modified = _set_modified_time(redis_client, uri)
      return response, modified
    end
  end
end