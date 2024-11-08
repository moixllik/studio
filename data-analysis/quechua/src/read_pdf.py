# Leer contenido en un PDF
# !pip install pdfplumber

import re
import pdfplumber
import pandas as pd
from IPython.display import display, clear_output

f_pdf = './data/diccionario.pdf'

with pdfplumber.open(f_pdf) as pdf:
    # print('Pages', len(pdf.pages)) # pag en PDF: 97 - 1346

    part = 1
    data = {}
    
    for page in range(96,1442):
        clear_output(wait=True)
        display(f'Página: {page}, data: {len(data.keys())}')
        
        texto = pdf.pages[page].extract_text_simple()
        for p in re.findall(r'[A-Z]+', texto):
            data[p] = 1

        if len(data.keys()) >= 2000 or page >= 1441:
            pd.DataFrame(data.keys(), columns=['palabras']).to_csv(f'./data/data_3-{part}.csv', header=False, index=False)
            part += 1
            data = {}
    
    pdf.close()
