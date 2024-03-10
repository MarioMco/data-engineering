from bs4 import BeautifulSoup
import requests
from decimal import Decimal
import pandas as pd
from dotenv import load_dotenv
import os

load_dotenv()
URL = os.getenv("URL")

def get_page_content(url):
    print(url)
    return requests.get(url).text

def extract_price(price_element):
    price_text = price_element.find("div", class_="new-price") or price_element
    price_text = price_text.text.strip().replace("\xa0", "").replace("€", ".")
    return Decimal(price_text)

def scrape_items_on_page(page_content):
    items_found = []
    doc = BeautifulSoup(page_content, "html.parser")
    items = doc.find_all(class_="pdt-item")
    for item in items:
        name = item.find("h3", class_="title-3").text
        description = item.find("p", class_="desc").text
        price = extract_price(item.find("div", class_="price"))
        items_found.append({"name": name, "description": description, "price": price})
    return items_found

def scrape_website(url, search):
    pages_url = f"{url}/recherche/{search}/"
    page_content = get_page_content(pages_url)
    doc = BeautifulSoup(page_content, "html.parser")
    page_text = doc.find(class_="pagination")

    items_found = []
    if page_text:
        pages = page_text.find_all("a")
        last_page = int(str(pages[-2]).split(">")[-2].split("<")[0])
        for page_num in range(2, last_page + 1):
            url = f"{pages_url}page{page_num}/"
            page_content = get_page_content(url)
            items_found.extend(scrape_items_on_page(page_content))
    else:
        items_found.extend(scrape_items_on_page(page_content))

    return items_found

if __name__ == "__main__":
    search = "rtx"
    store_data = "bs_scraping_data.csv"
    items_found = scrape_website(URL, search)
    df = pd.DataFrame(items_found)
    df.to_csv(store_data, index=False)
