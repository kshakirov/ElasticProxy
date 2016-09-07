require_relative '../proxy/decriptor'
decypher = CustomerInfoDecypher.new
str = 'odpZYaXPEDhGxUr/lz4VcuCT3dSyOs3+IqYLDeahmPo='
ec = Encoding::Converter.new("ascii-8", "utf-8")
str = ec.convert(str).dump
p str.size
p decypher.get_customer_group(str)
#6271&stats=odpZYaXPEDhGxUr/lz4Vcn7t0hRzsHcoZgrMPwpdrkA=

