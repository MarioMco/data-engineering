## Web scraping with Beautifulsoup

In this example we scrape product information from a webshop for items related to the search term "rtx." The scraped data includes the product name, description, and price.

### Libraries Used
 - Requests: Used to make HTTP requests to fetch web pages.
 - BeautifulSoup: Utilized for parsing HTML content.
 - Pandas: Used to create a DataFrame for storing the scraped data and exporting it to a CSV file.

### Functions
We have created several functions and below you can find descripton what they do.
#### get_page_content(url)
 - Input: url - The URL of the webpage to fetch.
 - Output: Returns the text content of the webpage fetched using the provided URL.
 - Description: This function makes an HTTP GET request to the provided URL and returns the textual content of the webpage.

#### extract_price(price_element)
 - Input: price_element - The HTML element containing the price information.
 - Output: Returns the price of the item as a Decimal.
 - Description: Extracts the price from the provided HTML element. It locates the element with the class "new-price" and then removes unwanted characters like non-breaking space and euro symbol before converting it into a Decimal.

#### scrape_items_on_page(page_content)
 - Input: page_content - The HTML content of a webpage.
 - Output: Returns a list of dictionaries containing product information.
 - Description: Scrapes product information from the provided HTML content. It finds all elements with the class "pdt-item" representing individual products and extracts their name, description, and price using appropriate HTML tags and classes.

#### scrape_website(search)
 - Input: search - The search term to look for on the webshop.
 - Output: Returns a list of dictionaries containing product information.
 - Description: Scrapes product information from a webshop pages related to the provided search term. It first constructs the URL based on the search term, fetches the content of the first page, and then iterates through additional pages if pagination is present, collecting product data from each page.