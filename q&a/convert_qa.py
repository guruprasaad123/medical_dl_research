from pandas import read_csv

df = read_csv(  './data/zeamed-web/answers.csv' , index_col=False , usecols=[2,3] )

df = df.rename( columns =  {  'title' : 'Question' ,  'content' : 'Answer'  } )

df.to_csv('./data/zeamed-web/zeamed-faq.csv' , index = False  ) # removes indexing while saving to .csv
