class SitemapsController < ApplicationController
  URLS_PER_SITEMAP = 5000 # 每个 sitemap 文件包含的 URL 数量

  def index
    response.headers['Content-Type'] = 'application/xml'
    response.stream.write '<?xml version="1.0" encoding="UTF-8"?>'
    response.stream.write '<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

    stream_sitemap_entry('https://www.pickupword.com/sitemap_main.xml', Time.now.iso8601)

    stream_paginated_entries(Article, 'articles')

    response.stream.write '</sitemapindex>'
  ensure
    response.stream.close
  end

  def show
    sitemap_type = params[:type]
    page = params[:page].to_i

    @sitemap = case sitemap_type
               when /^articles_\d+$/
                 generate_articles_sitemap(page)
               when 'main'
                 generate_main_sitemap
               else
                 render_404
               end

    render xml: @sitemap, content_type: 'application/xml' unless performed?
  end

  private

  def stream_sitemap_entry(loc, lastmod)
    response.stream.write "<sitemap><loc>#{loc}</loc><lastmod>#{lastmod}</lastmod></sitemap>"
  end

  def stream_paginated_entries(model, type)
    total_pages = (model.count / URLS_PER_SITEMAP.to_f).ceil
    total_pages.times do |i|
      page = i + 1
      last_entry = model.order(id: :asc).offset(i * URLS_PER_SITEMAP).first
      lastmod = last_entry&.updated_at&.iso8601 || Time.now.iso8601
      stream_sitemap_entry("https://www.pickupword.com/sitemap_#{type}_#{page}.xml", lastmod)
    end
  end

  def generate_main_sitemap
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") {
        add_url(xml, '/', 'daily', 1.0)
        add_url(xml, '/about', 'weekly', 0.8)

        add_url(xml, '/words/zh', 'daily', 0.9)
        add_url(xml, '/sentences/zh', 'daily', 0.9)
      }
    end.to_xml
  end

  def generate_articles_sitemap(page)
    Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
      xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") {
        # ...
      }
    end.to_xml
  end

  def add_url(xml, loc, changefreq = nil, priority = nil, lastmod = nil)
    xml.url {
      xml.loc "https://www.pickupword.com#{loc}"
      xml.lastmod lastmod.iso8601 if lastmod
      xml.changefreq changefreq if changefreq
      xml.priority priority if priority
    }
  end
end
