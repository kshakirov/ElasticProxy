class PriceManager
  def process_product_price product
    prices = product['_source']['price']
    price = 0.0;
      if prices.class.to_s == 'Hash' and prices.key? '7'
            price = prices['7']
            price = price.to_f.round(2)
      end
    product['_source']['price'] = price.to_s + " $"
  end

  def get_simple_price response
    products = response['hits']['hits']
    products.each do |product|
      process_product_price product
    end

  end
end