import pandas as pd
import numpy as np
from bs4 import BeautifulSoup, element

df = pd.DataFrame(columns=['lang', 'title'])

with open('./data/1-jornal.html', 'r') as file:
    soup = BeautifulSoup(file.read(), 'lxml')
    results = soup.find_all('div', class_='result-content')
    for link in results:
        #print('pt', link.find('span').text.strip())   # title
        df.loc[len(df)] = ['pt', link.find('span').text.strip()]

with open('./data/2-jornal.html', 'r') as file:
    soup = BeautifulSoup(file.read(), 'lxml')
    main = soup.find('main')
    results = main.find_all('a', target='_blank')
    for link in results:
        #print('en', link.text.strip()) # title
        df.loc[len(df)] = ['en', link.text.strip()]

with open('./data/3-jornal.html', 'r') as file:
    soup = BeautifulSoup(file.read(), 'lxml')
    results = soup.find_all('a', class_='title')
    for link in results:
        #print('pt', link.text.strip()) # title
        df.loc[len(df)] = ['pt', link.text.strip()]

df.replace('', np.nan, inplace=True)
df.dropna().drop_duplicates().to_csv('./data/data.csv', index=False)
