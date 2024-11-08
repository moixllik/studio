# Uso de Spark para almacenar los datos (requiere Java JDK)
# !pip install pyspark
# docker run -it --rm spark:python3 /opt/spark/bin/pyspark

from pyspark.sql import SparkSession

from pyspark.sql.functions import regexp_replace, col

# !pip install matplotlib

import pandas as pd
import matplotlib.pyplot as plt


spark = SparkSession.builder.appName('Quechua').getOrCreate()

df = spark.read.csv('./data/data_3*.csv', header=False, inferSchema=True)
df = df.dropDuplicates()
print('Total: ', df.count())



df_vocales = df.withColumn('Vocales', regexp_replace(col('_c0'), r'[^AEIOU]', ''))
df_vocales.show()


# Requeridos
vocales = {'A': 0, 'E': 0, 'I': 0, 'O': 0, 'U': 0}

for row in df_vocales.toLocalIterator():
    for vocal in list(row['Vocales']):
        vocales[vocal] += 1

print(vocales)



df_final = pd.DataFrame(list(vocales.items()), columns=['Vocal', 'Total'])
ax = df_final.plot(kind='bar', x='Vocal', y='Total', legend=False)

ax.bar_label(ax.containers[0])

plt.savefig('./fig-1.png')
plt.show()
