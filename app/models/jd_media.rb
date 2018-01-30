class JdProduct < ApplicationRecord
  self.table_name = "zhinan_products"
end

class JdCollection < ApplicationRecord
  self.table_name = "zhinan_collections"
end

class Link < ApplicationRecord
  self.table_name = 'xiongmao_links'
end
