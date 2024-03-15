# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


from itemadapter import ItemAdapter
import psycopg2


class WebshopscraperPipeline:
    def process_item(self, item, spider):
        
        adapter = ItemAdapter(item)
        # Strip all whitespaces from strings
        product_keys = ["product", "description", "product_info", "product_url"]
        for product_key in product_keys:
            name_string = adapter.get(product_key)
            adapter[product_key] = name_string[0].strip()
        
        # Price --> convert to float     
        price_keys = ["price","price_excl_tax"]
        for price_key in price_keys:
            if price_key == "price":
                value = adapter.get(price_key)
                adapter[price_key] = float(value[0])
            else:
                value = adapter.get(price_key)
                adapter[price_key] = float(value)
        
        return item
            
class SaveToPostgreSQLPipeline:
    
    def __init__(self):
        self.conn = psycopg2.connect(
            host='localhost', 
            user='postgres',
            password='postgres', 
            dbname='scrapydemo', 
            port=5432)
    
        self.cur = self.conn.cursor()
        
        self.cur.execute("""
        CREATE TABLE IF NOT EXISTS products(
            id SERIAL PRIMARY KEY,
            product_url text NULL,
            product text NULL,
            product_info text NULL,
            description text NULL,
            price DECIMAL NULL,
            price_excl_tax DECIMAL NULL
        )
                         """)
        
    def process_item(self, item, spider):
        self.cur.execute("""
        INSERT INTO products(
            product_url,
            product,
            product_info,
            description,
            price,
            price_excl_tax
        ) VALUES(
            %s, %s, %s, %s, %s, %s
        )             
        """,(
        item["product_url"],
        item["product"],
        item["product_info"],
        item["description"],
        item["price"],
        item["price_excl_tax"]))
        
        self.conn.commit()
        return item

    def close_spider(self, spider):
        self.cur.close()
        self.conn.close()