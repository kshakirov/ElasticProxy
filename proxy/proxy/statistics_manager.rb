class StatisticsManager
  def initialize
      @decryptor = CustomerInfoDecypher.new
  end

  def _get_rid_of_zero_char customer_id
      customer_id.gsub(0.chr.to_s, '')
  end

  def _insert_customer_id query, customer_id
    query['query']['match'] = {'customer_id' => customer_id}
    query
  end

  def _insert_visitor_id query, session_id
    query['query']['match'] = {'visitor_id' => session_id}
    query
  end

  def create_query  stats, session_id , query
      customer_id = @decryptor.get_customer_id stats
      if customer_id
        _insert_customer_id(query, _get_rid_of_zero_char(customer_id))
      else
        _insert_visitor_id(query, session_id)
      end
  end

  def create_update_query stats, session_id, body
    customer_id = @decryptor.get_customer_id stats
    unless customer_id == 'no stats'
      body['customer_id'] = _get_rid_of_zero_char(customer_id)
    end
    body['visitor_id'] = session_id
    body['store_id'] = 1
    body
  end
end