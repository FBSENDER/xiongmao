require 'taobao'
class TaobaoController < ApplicationController
  def baobei
    @product = Product.where(item_id: params[:id].to_i).take
    not_found if @product.nil?
    @detail = ProductDetail.where(item_id: @product.item_id).take
    @title = @detail.nil? ? "#{@product.title}_我剁手都要买的宝贝" : "#{@detail.short_title}_剁手都要买的宝贝"
    @categories = []
    @categories += @product.cate_name.split('/')
    @categories << @product.cate_leaf_name unless @product.cate_leaf_name.empty?
    @keywords = "#{@product.title},#{@product.nick},#{@categories.join(',')}"
    @description = "【剁手都要买的宝贝(#{@product.title}})】#{@product.title} - 分类#{@product.cate_name}/#{@product.cate_leaf_name}，原价#{@product.origin_price}元，现价#{@product.price}元，天猫淘宝#{@product.nick}热卖中，本月销量#{@product.volume}，优惠券领取，降价折扣查询，宝贝精选 - 熊猫优选"
    @path = request.path + "/"
    @shop = Shop.where(source_id: @product.seller_id).take
    @suggest_keywords = get_suggest_keywords_new(@categories[-1])
    @coupon = Coupon.where(item_id: @product.item_id).take
    @same_shop_products = Product.where(seller_id: @product.seller_id).select(:item_id, :title,:pic_url, :origin_price, :price, :nick)
    @related_products = Product.where("id > ?", @product.id).select(:item_id, :title,:pic_url, :origin_price, :price, :nick).order(:id).limit(10)
    @related_shops = Shop.where("id > ?", @shop.id).select(:source_id, :title, :nick, :pic_url).limit(10) if @shop
    @new_products = Product.select(:item_id, :title,:pic_url, :origin_price, :price, :nick).order("id desc").limit(10)
    @hot_products = []
  end

  def youxuan
    @keyword = params[:keyword].strip
    @title = "#{@keyword}_#{@keyword}【价格 图片 打折 包邮】_天猫淘宝#{@keyword}_熊猫优选"
    @keywords = "#{@keyword},#{@keyword}价格,#{@keyword}图片,#{@keyword}打折,#{@keyword}包邮,淘宝#{@keyword},天猫#{@keyword}"
    @description = "#{@keyword}优惠专场，实时更新高性价比#{@keyword}单品、淘宝#{@keyword}打折特卖信息，全场低至1折起包邮，敬请关注！这些#{@keyword}都是由专业编辑为您精挑细选的，欢迎进入页面了解#{@keyword}价格、#{@keyword}图片等相关信息！熊猫优选致力于帮您节省浏览海量商品信息时间，让您以更优惠的折扣价格购买到自己喜欢的#{@keyword}！"
    @path = request.path + "/"
    @suggest_keywords = get_suggest_keywords_new(@keyword)
    @products = get_products_by_keyword(@keyword)
    @shops = Shop.where(source_id: @products.map{|pd| pd.seller_id}).select(:source_id, :title, :nick, :pic_url)
    @new_products = Product.select(:item_id, :title,:pic_url, :origin_price, :price, :nick).order("id desc").limit(10)
    @hot_products = []
  end

  def dian
    @shop = Shop.where(source_id: params[:id].to_i).take
    not_found if @shop.nil?
    shop_title = @shop.title.include?("旗舰店") ? @shop.title : @shop.title + "旗舰店"
    @title = "#{shop_title}首页,#{@shop.title}优惠券/信誉/评价怎么样"
    @keywords = "#{shop_title},#{@shop.title},#{@shop.title}首页,#{shop_title}首页,#{@shop.title}优惠券,#{@shop.title}信誉,#{@shop.title}评价,#{@shop.title}怎么样"
    @dsr_info = JSON.parse(@shop.dsr_info)
    ind = JSON.parse(@dsr_info["dsrStr"])["ind"]
    @description = "#{@shop.title}是一家经营信誉良好、获得消费者广泛好评的一家#{@shop.is_tmall == 1 ? '天猫' : '淘宝'}店铺。店铺掌柜为#{@shop.nick}，如果大家有任何关于#{@shop.title}的问题，都可以向其进行咨询。店铺的注册地点在#{@shop.provcity}，全国包邮哦，看到合适的宝贝赶快拍下，#{@shop.provcity}附近的朋友们可能在当天就收到快递喽。#{@shop.title}在售的宝贝有#{@shop.totalsold}件，有木有很多！近30天的销量为#{@shop.procnt}件，代掌柜#{@shop.nick}感谢大家的大力支持。#{@shop.title}主营类目为#{ind}，具体有#{@shop.main_auction}，欢迎大家选购。#{@shop.title}的综合评分还是不错的，在宝贝描述相符、服务态度、物流服务上均在平均水平之上，大家可以放心选购自己心仪的宝贝。还在等什么？快去#{@shop.title}逛一逛~"
    @path = request.path + "/"
    @suggest_keywords = get_suggest_keywords_new(@shop.search_keyword)
    @products = Product.where(seller_id: @shop.source_id).select(:item_id, :title,:pic_url, :origin_price, :price, :nick)
    @shops = Shop.where("id > ?", @shop.id).order(:id).limit(10).select(:source_id, :title, :nick, :pic_url)
    @new_products = Product.select(:item_id, :title,:pic_url, :origin_price, :price, :nick).order("id desc").limit(10)
    @hot_products = []
  end

  def product_map
    @products = Product.select(:item_id, :title).order(:id).limit(500).offset(200 * params[:page].to_i)
    not_found if @products.size.zero?
    @page = params[:page].to_i
  end

  def shop_map
    @shops = Shop.select(:source_id, :title).order(:id).limit(500).offset(500 * params[:page].to_i)
    not_found if @shops.size.zero?
    @page = params[:page].to_i
  end

  def get_suggest_keywords_new(keyword)
    begin
      sk = SuggestKeyword.where(keyword: keyword).take
      return [] if sk.nil?
      sk.sks.split(',')
    rescue
      return []
    end
  end

  def get_products_by_keyword(keyword)
    result = SearchResult.where(keyword: keyword).take
    return [] if result.nil?
    item_ids = CS.where(coupon_id: result.coupon_ids.split(',').map{|c| c.to_i}).pluck(:item_id)
    Product.where(item_id: item_ids).select(:item_id, :title, :pic_url, :origin_price, :price, :seller_id, :nick, :is_tmall, :volume).to_a
  end
end
