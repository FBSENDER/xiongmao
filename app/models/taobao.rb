class Product < ApplicationRecord
  self.table_name = 'iquan_products'
end

class ProductDetail < ApplicationRecord
  self.table_name = 'iquan_product_details'
end

class Shop < ApplicationRecord
  self.table_name = 'iquan_shops'
end

class SuggestKeyword < ApplicationRecord
  self.table_name = 'iquan_suggest_keywords'
end

class Coupon < ApplicationRecord
  self.table_name = 'iquan_product_coupons'
end

class SearchResult < ApplicationRecord
  self.table_name = 'iquan_search_results'
end

class CS < ApplicationRecord
  self.table_name = 'iquan_coupon_suggestions'
end
