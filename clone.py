#!/bin/python

import requests
from pprint import pprint
from dotenv import dotenv_values

config = dotenv_values('.env')

def doRequest(payload):
    response = requests.get('https://api.github.com/user/repos', params=payload, auth=(config['USERNAME'],config['TOKEN']))
    #pprint(response.json)
    for repo in response.json():
        print(repo['url'])
        print(repo['language'] if repo['language'] else 'Others', end='') 
        print('...'+repo['url'])
    return len(response.json())


items = doRequest({'page': '0', 'per_page': '100'})

while items > 100:
    items = doRequest({'page': items, 'per_page': '100'})
