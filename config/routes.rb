Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "jd_media#collection_home"
  #get "collection/:id", to: "jd_media#collection"
  #get "cc/:id", to: "jd_media#collection_category"
  #get "jdsku/:id", to: "jd_media#jdsku"
  get "data", to: "jd_media#data"

  #zsh
  get "zp/:id", to: "zsh#item"
  get "zs/:id", to: "zsh#shop"
  get "map-product-:letter-:page.html", to: "zsh#product_map"
  get "map-shop-:letter-:page.html", to: "zsh#shop_map"
  get "zxgt", to: "zsh#xgt_home"
  #get "zxgt/:id-0-0-0-0-0-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  #get "zxgt/0-:id-0-0-0-0-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  #get "zxgt/0-0-:id-0-0-0-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  #get "zxgt/0-0-0-:id-0-0-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  #get "zxgt/0-0-0-0-:id-0-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  #get "zxgt/0-0-0-0-0-:id-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  get "zxgt/:id1-:id2-:id3-:id4-:id5-:id6-0-0-0-0", to: "zsh#xgt"
  get "zxgt/:id1-:id2-:id3-:id4-:id5-:id6-0-0-0-0/new", to: "zsh#xgt"
  get "zxgt/:id1-:id2-:id3-:id4-:id5-:id6-0-0-0-0/hot", to: "zsh#xgt"
  #get "zxgt/0-0-0-0-0-0-0-0-0-0", to: "zsh#xgt"
  #get "zpic/0-0-0-0-0-0-0-0-0-0", to: "zsh#pic"
  #get "zbuy/0-0-0-0-0-0-0-0-0-0", to: "zsh#buy"
  #热销榜
  get "hot", to: "zsh#hot"
  #最新优惠
  get "new_coupons", to: "zsh#new_coupons"
  #好评榜
  get "hot_comments", to: "zsh#hot_comments"
  #新品
  get "new_items", to: "zsh#new_items"
  #recommend
  get "recommend", to: "zsh#recommend"

  # taobao
  #get "baobei/:id", to: "taobao#baobei"
  #get "youxuan/:keyword", to: "taobao#youxuan"
  #get "dian/:id", to: "taobao#dian"
  #get "product_map", to: "taobao#product_map"
  #get "shop_map", to: "taobao#shop_map"
end
