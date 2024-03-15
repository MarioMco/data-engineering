import scrapy
from webshopscraper.items import ProductItem
from dotenv import load_dotenv
import os

load_dotenv()
SITE_URL = os.getenv("SITE_URL")
START_URLS = [os.getenv("START_URLS")]
ALLOWED_DOMAINS = [os.getenv("ALLOWED_DOMAINS")]



class WebshopspiderSpider(scrapy.Spider):
    
    
    name = "webshopspider"
    allowed_domains = ALLOWED_DOMAINS
    start_urls = START_URLS

    def parse(self, response):
        products = response.css('li.pdt-item')
        
        for product in products:
            realitve_url = product.css('h3.title-3 a ::attr(href)').get()
        
            product_url = SITE_URL + realitve_url
                
            yield response.follow(product_url, callback = self.parse_product_page)
            
        next_page = response.css("li.next a::attr(href)").get()
        
        if next_page is not None:
            next_page_url = SITE_URL + next_page
            
                
            yield response.follow(next_page_url, callback = self.parse)
            
    def parse_product_page(self, response):
        item = ProductItem()

        item["product_url"] = response.url,
        item["product"] = response.css('h1.title-1::text').get(),
        item["product_info"] = response.css('.title h2::text').get(),
        item["description"] = response.css('p.desc ::text').get(),
        item["price"] = response.css('div#product-page-price::attr(data-product-price-vat-on)').get(),
        item["price_excl_tax"] = response.css('div#product-page-price::attr(data-product-price-vat-off)').get()

        yield item
        
