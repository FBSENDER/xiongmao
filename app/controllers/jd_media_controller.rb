require 'jd_media'
require 'zsh'
class JdMediaController < ApplicationController

  def collection_home
    @items = ZshProduct.where("dtitle like ?", "%黑白%").select(:id, :dtitle, :mainPic, :desc).order("id desc").limit(60)
    @shops = ZshShop.select(:id, :shopName, :shopLogo).order(:id).limit(10)
    @path = ""
    @links = Link.where(status: 1).select(:anchor, :url)
    @tags = []
    za = ZshAttr.select(:id, :name, :sort, :type_id, :alias).to_a
    za.each do |attr|
      link = attr.type_id == 1 ? "/zxgt/#{attr.id}-0-0-0-0-0-0-0-0-0/" :
             attr.type_id == 2 ? "/zxgt/0-#{attr.id}-0-0-0-0-0-0-0-0/" :
             attr.type_id == 3 ? "/zxgt/0-0-#{attr.id}-0-0-0-0-0-0-0/" :
             attr.type_id == 4 ? "/zxgt/0-0-0-#{attr.id}-0-0-0-0-0-0/" :
             attr.type_id == 5 ? "/zxgt/0-0-0-0-#{attr.id}-0-0-0-0-0/" :
                                 "/zxgt/0-0-0-0-0-#{attr.id}-0-0-0-0/" 
      @tags << {name: attr.name, link: link}
    end
    @tags = @tags.sample(30)
    file = Rails.root.join("public").join("home.html")
    if !File.exists?(file)
      @content = ""
    else
      @content = File.read(file)
    end
  end

  def collection
    @collection = JdCollection.where(id: params[:id].to_i).take
    not_found if @collection.nil?
    @skus = JdProduct.where(sku_id: @collection.sku_ids.split(',')).select(:id, :sku_id, :title, :description, :img_url, :ad_url, :price, :o_price).to_a
    if @skus.size % 2 == 1
      @skus << @skus[@skus.size - 1]
    end
    ids = JdCollection.where(category: @collection.category).pluck(:id)
    @cs = JdCollection.where(id: ids.sample(10)).select(:id, :title, :sku_img_urls, :description)
    @path = request.path + "/"
    @is_robot = is_robot?
    if(@collection.c_type == 1)
      render :collection_1
    else
      render :collection_2
    end
  end

  def collection_category
    page = params[:page].nil? ? 0 : params[:page].to_i
    @cs = JdCollection.where(category: params[:id].to_i).select(:id, :title, :sku_img_urls, :description).offset(20 * page).limit(20)
    not_found if @cs.nil? || @cs.size.zero?
    count = JdCollection.where(category: params[:id].to_i).count
    @page_count = (count * 1.0 / 20).ceil
    @title = case params[:id].to_i
             when 1 then '服饰购买指南'
             when 2 then '礼物挑选指南'
             when 3 then '美妆购买指南'
             when 4 then '娱乐商品购买指南'
             when 5 then '美食购物指南'
             when 6 then '图书购买指南'
             when 7 then '精选购物指南'
             else '购物指南'
             end
    @path = request.path + "/"
  end

  def jdsku
    @sku = JdProduct.where(id: params[:id].to_i).take
    not_found if @sku.nil?
    @skus = JdProduct.where(id: (1..14000).to_a.sample(20)).select(:id, :sku_id, :title, :img_url, :price, :o_price, :ad_url).to_a
    @path = request.path + "/"
    @cs = JdCollection.where(id: (1..1890).to_a.sample(10)).select(:id, :title, :sku_img_urls, :description)
  end

  def data
    @cs = JdCollection.where(status: 1, c_type: 1).select(:id, :title, :description, :img_url, :sku_img_urls).order("id desc").take(100)
    render json: @cs
  end
end
