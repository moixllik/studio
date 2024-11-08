import requests

def get_data(index, url):
    response = requests.get(url)
    if (response.status_code == 200):
        with open('./data/' + str(index) + '-jornal.html', 'w', encoding='utf-8') as file:
            file.write(response.text)

with open('./list.txt', 'r') as file:
    for index, line in enumerate(file, start=1):
        get_data(index, line.strip())
