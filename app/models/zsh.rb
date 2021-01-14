class ZshProduct < ApplicationRecord
  self.table_name = "zsh_products"
end

class ZshShop < ApplicationRecord
  self.table_name = 'zsh_shops'
end

class ZshProductComment < ApplicationRecord
  self.table_name = 'zsh_product_comments'
end

class ZshAttrList < ApplicationRecord
  self.table_name = 'zsh_attr_list'
end

class ZshAttr < ApplicationRecord
  self.table_name = 'zsh_attrs'
end

class ZshTdk < ApplicationRecord
  self.table_name = 'zsh_tdks'
end
