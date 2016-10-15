class ProductPriceManager
  def initialize
    @decryptor = CustomerInfoDecypher.new
  end

  def forbid_product_price response
     response['prices'] = "Unauthorized"
  end

  def process_product_price response, group_id
    if response['prices'].class.to_s == 'Hash' and response['prices'].key? group_id
      price = response['prices'][group_id]
      response['prices'] = price.to_f.round(2)
    else
      response['prices'] = 0.0
    end
  end

  def get_simple_price response, group_id
    group_id = @decryptor.get_customer_group group_id if group_id
    if group_id.include? 'not_authorized'
      forbid_product_price response
    elsif group_id.size > 0
      process_product_price response, group_id
    end
  end

end