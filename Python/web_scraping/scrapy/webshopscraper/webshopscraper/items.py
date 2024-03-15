# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class ProductItem(scrapy.Item):
    product_url = scrapy.Field()
    product = scrapy.Field()
    product_info = scrapy.Field()
    description = scrapy.Field()
    price = scrapy.Field()
    price_excl_tax = scrapy.Field()
