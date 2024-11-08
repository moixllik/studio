# Descargar los archivos de datos
# !pip install requests

import os
import requests

data = {
    'runasimi.txt': 'https://www.runasimi.de/runasimi.txt',
    'runasimi.zip': 'https://www.runasimi.de/runasimi.zip',
    'diccionario.pdf': 'https://fcctp.usmp.edu.pe/librosfcctp/DICCIONARIO-Quechua-espanol-VOL_2.pdf'
}

if not os.path.exists('./data'):
    os.makedirs('./data')

for fname, url  in data.items():
    fpath = './data/' + fname
    print(fpath)
    if not os.path.exists(fpath):
        with requests.get(url, stream=True, verify=False) as r:
            r.raise_for_status()
            with open(fpath, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    f.write(chunk)
