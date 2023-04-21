from bs4 import BeautifulSoup
import requests
import boto3

url="https://search.longhornrealty.com/idx/results/listings?pt=4&a_propStatus%5B%5D=Active&ccz=city&idxID=c007&per=25&srt=newest&city%5B%5D=22332&city%5B%5D=45916"
page = requests.get(url)


def lambda_handler(event, context):
    try:
        soup = BeautifulSoup(page.content, "html.parser")
        results = soup.find(id="idx-results-category-active")
        listings = results.find_all("article")

        for listing in listings:
            prices = listing.find(
                'div', {'class': 'idx-listing-card__price'}).get_text()
            address_city = listing.find(
                'span', {'class': 'idx-listing-card__address--City'}).get_text()
            print(prices, address_city)
    except Exception as e:
        print(e)
