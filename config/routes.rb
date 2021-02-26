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
  #get "zxgt/:id-0-0-0-0-0-0-0-0-0", to: "zsh#xgt_only_1", id: /\d+/
  #get "zxgt/0-0-0-0-0-0-0-0-0-0", to: "zsh#xgt"
  #get "zpic/0-0-0-0-0-0-0-0-0-0", to: "zsh#pic"
  #get "zbuy/0-0-0-0-0-0-0-0-0-0", to: "zsh#buy"

  # taobao
  #get "baobei/:id", to: "taobao#baobei"
  #get "youxuan/:keyword", to: "taobao#youxuan"
  #get "dian/:id", to: "taobao#dian"
  #get "product_map", to: "taobao#product_map"
  #get "shop_map", to: "taobao#shop_map"
end
