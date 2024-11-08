# Leer documento en texto separado por tabs (TSV)
# !pip install pandas

import pandas as pd

f_txt = './data/runasimi.txt'

df_txt = pd.read_csv(f_txt, sep='\t', encoding='latin1')
print(df_txt.columns)
df_txt['Ayakuchu'].dropna().str.upper().to_csv('./data/data_1.csv', header=False, index=False)
