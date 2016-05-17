class PriceManager

  def initialize
    @decryptor = CustomerInfoDecypher.new
  end

  def get_rid_of_php_ascii group_id
    id = ""
    group_id.each_byte do |b|
      if b != 0 and  b != 39
        id << b.chr
      end
    end
    id
  end

  def process_product_price product, group_id
    id = get_rid_of_php_ascii group_id
    prices = product['_source']['price']
    price = 0.0
      if prices.class.to_s == 'Hash' and prices.key? id
            price = prices[id]
            price = price.to_f.round(2)
      end
    product['_source']['price'] = price.to_s + " $"
  end

  def forbid_product_price product
    product['_source']['price'] = "Unauthorized"
  end


  def get_simple_price response, group_id
    group_id = @decryptor.get_customer_group group_id if group_id
    products = response['hits']['hits']
    products.each do |product|
      if group_id.include?'not_authorized'
        forbid_product_price product
      elsif group_id.size > 0
        process_product_price product, group_id
      end
    end

  end
end