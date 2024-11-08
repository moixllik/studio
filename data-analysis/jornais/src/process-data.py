import pandas as pd
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer
import leia.leia as pt

nltk.download('vader_lexicon')
sia_en = SentimentIntensityAnalyzer()
sia_pt = pt.SentimentIntensityAnalyzer()

def analyzer(lang, text):
    if lang == 'en':
        return sia_en.polarity_scores(text)
    elif lang == 'pt':
        return sia_pt.polarity_scores(text)



df = pd.read_csv('./data/data.csv')
df['neg'] = 0.0
df['neu'] = 0.0
df['pos'] = 0.0
df['compound'] = 0.0

for index, row in df.iterrows():
    score = analyzer(row.lang, row.title)
    if score:
        df.loc[index, 'neg'] = score['neg']
        df.loc[index, 'neu'] = score['neu']
        df.loc[index, 'pos'] = score['pos']
        df.loc[index, 'compound'] = score['compound']


stats = df.describe()
print(stats.to_markdown())
