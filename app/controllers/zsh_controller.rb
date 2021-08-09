require 'zsh'
class ZshController < ApplicationController
  def item
    #商品主体内容
    #店铺/品牌信息
    #用户评论
    #相关商品
    #到某些A页面的链接
    id = params[:id].to_i
    not_found if id <= 0
    @item = ZshProduct.where(id: id).select(:id, :goodsId, :title, :dtitle, :desc, :mainPic, :actualPrice, :originalPrice, :brandName, :sellerId).take
    @item.dtitle = @item.title if @item.dtitle.empty?
    not_fount if @item.nil?
    @shop = ZshShop.where(sellerId: @item.sellerId).select(:id, :sellerId, :shopName, :shopType, :shopLogo).take
    c = ZshProductComment.where(product_id: @item.id).select(:comments).take
    @comments = c.nil? ? [] : JSON.parse(c.comments)
    @r = ZshProduct.where("id > ?", @item.id).order(:id).select(:id, :title, :dtitle, :mainPic, :actualPrice, :originalPrice).limit(20)
    @tags = []
    ZshAttr.select(:id, :name, :type_id).to_a.each do |attr|
      if @item.title.include?(attr.name)
        link = attr.type_id == 1 ? "/zxgt/#{attr.id}-0-0-0-0-0-0-0-0-0/" :
               attr.type_id == 2 ? "/zxgt/0-#{attr.id}-0-0-0-0-0-0-0-0/" :
               attr.type_id == 3 ? "/zxgt/0-0-#{attr.id}-0-0-0-0-0-0-0/" :
               attr.type_id == 4 ? "/zxgt/0-0-0-#{attr.id}-0-0-0-0-0-0/" :
               attr.type_id == 5 ? "/zxgt/0-0-0-0-#{attr.id}-0-0-0-0-0/" :
                                   "/zxgt/0-0-0-0-0-#{attr.id}-0-0-0-0/" 
        @tags << {name: attr.name, link: link}
      end
    end
    @path = request.path + "/"
  end

  def shop
    id = params[:id].to_i
    not_found if id <= 0
    @shop = ZshShop.where(id: id).select(:id, :sellerId, :shopName, :shopLevel, :shopType, :shopLogo).take
    not_found if @shop.nil?
    @r = ZshProduct.where(sellerId: @shop.sellerId).select(:id, :title, :dtitle, :mainPic, :actualPrice, :originalPrice).to_a
    @ss = ZshShop.where("id > ?", @shop.id).select(:id, :shopName, :shopLogo).order(:id).limit(5)
    @path = request.path + "/"
  end

  def xgt_home
    page = params[:page].to_i
    @page = page <= 0 ? 1 : page
    not_found if @page > 10
    @all = ZshAttr.select(:id, :name, :sort, :type_id, :alias).to_a
    @items = get_dg_items("装饰画", @page)
    @a = ZshAttr.new
    @title = "装饰画怎么选择,选购装饰画"
    @r = ZshProduct.where(id: (1..93).to_a.sample(10)).select(:id, :title, :dtitle, :mainPic, :actualPrice, :originalPrice).to_a
    @ss = ZshShop.where(id: (1..43).to_a.sample(5)).select(:id, :shopName, :shopLogo)
    @path = "/zxgt/"
    render "xgt"
  end

  def xgt_only_1
    id = params[:id].to_i
    not_found if id <= 0
    page = params[:page].to_i
    @page = page <= 0 ? 1 : page
    not_found if @page > 10
    @all = ZshAttr.select(:id, :name, :sort, :type_id, :alias).to_a
    @a = @all.select{|x| x.id == id}.first
    not_found if @a.nil?
    @items = get_dg_items("#{@a.name}装饰画", @page)
    @title = @a.alias.empty? ? "#{@a.name}装饰画" : @a.alias.split(',').map{|x| "#{x}装饰画"}.join(',')
    @r = ZshProduct.where(id: (1..93).to_a.sample(10)).select(:id, :title, :dtitle, :mainPic, :actualPrice, :originalPrice).to_a
    @ss = ZshShop.where(id: (1..43).to_a.sample(5)).select(:id, :shopName, :shopLogo)
    @path = request.path + "/"
    render "xgt"
  end

  def get_dg_items(keyword, page)
    url = "http://api.uuhaodian.com/uu/dg_goods_list?keyword=#{keyword}&page=#{page}"
    result = Net::HTTP.get(URI(URI.encode(url)))
    json = JSON.parse(result)
    if json["status"] == 1
      return json["results"]
    else
      return []
    end
  end
end
