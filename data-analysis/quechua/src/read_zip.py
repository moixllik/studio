# Un archivo Excel dentro de un Zip comprimido
# !pip install xlrd

import pandas as pd
import zipfile


f_zip = './data/runasimi.zip'
f_xls = 'runasimi.xls'

with zipfile.ZipFile(f_zip, 'r') as z:
    with z.open(f_xls) as f:
        df_xls = pd.read_excel(f)
        print(df_xls.columns)
        df_xls['Ayakuchu'].dropna().str.upper().to_csv('./data/data_2.csv', header=False, index=False)
