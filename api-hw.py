import json
import pandas as pd
import json
import requests
from dotenv import load_dotenv
import os

load_dotenv()

# take user input for a stock using Ticker symbol with input command 
stock = input().upper()
print("Getting info for Ticker " + stock + '...') # ticker name


apikey = os.getenv('YAHOO_API_KEY')

# first APL call - get current price and other information
url_1 = "https://yfapi.net/v6/finance/quote"

querystring_1 = {"symbols": stock}
headers = {
    'x-api-key': apikey
}

response_1 = requests.request("GET", url_1, headers=headers, params=querystring_1)


# Initialize variables so default = N/A
company_name = "N/A"
current_price = "N/A"
fifty_two_week_high = "N/A"
fifty_two_week_low = "N/A"
target_mean_price = "N/A"

# check response from first API
if response_1.status_code == 200:
    stock_json_1 = response_1.json()

    if stock_json_1['quoteResponse']['result']:
        stock_info = stock_json_1['quoteResponse']['result'][0]

        company_name = stock_info.get("longName", "N/A")
        current_price = stock_info.get("regularMarketPrice", "N/A")
        fifty_two_week_high = stock_info.get("fiftyTwoWeekHigh", "N/A")
        fifty_two_week_low = stock_info.get("fiftyTwoWeekLow", "N/A")
    else: 
        print("Stock not found.")
else: 
    print(f"Failed to fetch stock data: {response_1.status_code} - {response_1.text}")


# second API call - get target_mean_price
url_2 = f"https://yfapi.net/v11/finance/quoteSummary/{stock}"
querystring_2 = {"lang": "en", "region": "US", "modules": "financialData"}  # Specify the modules you want
response_2 = requests.get(url_2, headers=headers, params=querystring_2)

if response_2.status_code == 200:
    stock_json_2 = response_2.json()

    if stock_json_2['quoteSummary']['result']:
        financial_data = stock_json_2['quoteSummary']['result'][0]['financialData']
        target_mean_price = financial_data.get('targetMeanPrice', {}).get('raw', 'N/A')

    else: 
        print("Stock not found.")
else: 
    print(f"Failed to fetch stock data: {response_2.status_code} - {response_2.text}")

# Print out the stock information
if response_2.status_code == 200 and response_1.status_code == 200:
    print(f"{company_name} Price: ${current_price}") # full name of stock + current market price
    print(f"Target Mean Price: ${target_mean_price}") # target mean price
    print(f"52 Week High: ${fifty_two_week_high}") # 52 week high
    print(f"52 Week Low: ${fifty_two_week_low}") # 52 week low
                                        
top_5_trending_stocks = []

# output 5 of current trending stock
# 3rd API call
trending_url = 'https://yfapi.net/v1/finance/trending/US'
trending_response = requests.get(trending_url, headers=headers)

if trending_response.status_code == 200:
    trending_json = trending_response.json()
    # print(trending_json)
    trending_stocks = trending_json['finance']['result'][0]['quotes']
    print("Top 5 trending stocks in the US: ")
    top_5_trending_stocks = [s['symbol'] for s in trending_stocks[:5]]

    # print(top_5_trending_stocks)
    for rank, s in enumerate(top_5_trending_stocks, start=1):
        print(f"Rank {rank} - Ticker: {s}")
else: 
    print(f"Failed to fetch stock data: {trending_response.status_code} - {trending_response.text}")

    
# Create a dataframe to store all data
df = pd.DataFrame({
    'Ticker': [stock],
    'Company Name': [company_name],
    'Current Price': [current_price],
    'Target Mean Price': [target_mean_price],
    '52 Week High': [fifty_two_week_high],
    '52 Week Low': [fifty_two_week_low],
    'Top 5 Current Trending Stocks': [top_5_trending_stocks]
})

# Convert data into a CSV file
df.to_csv(f'{stock}-data.csv', header=True, index=False)
print(f'CSV created named {stock}-data.csv')

# print(df)