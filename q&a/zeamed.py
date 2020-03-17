from pandas import DataFrame , read_csv
from nltk.tokenize import sent_tokenize

from cdqa.utils.filters import filter_paragraphs
from cdqa.utils.download import download_model, download_bnpp_data
from cdqa.pipeline.cdqa_sklearn import QAPipeline


def get_sentences(values=[]):
  sentences = []
  for value in values:
    tokens = sent_tokenize(value)
    sentences += tokens
  return sentences


df = read_csv('./data/zeamed-web/answers.csv',index_col=False,usecols=[1,2,3])

consumer = df['type']=='consumer'
provider = df['type']=='provider'

consumer_data = df[consumer]
provider_data = df[provider]

consumer_sentences = get_sentences(consumer_data['content'].values)
provider_sentences = get_sentences(provider_data['content'].values)

# print('consumer_sentences ',consumer_sentences)

obj = {
  'title':['consumer','provider'] ,'paragraphs':[ consumer_sentences , provider_sentences ]
}

data_frame = DataFrame(data=obj)

cdqa_pipeline = QAPipeline(reader='models/bert_qa.joblib')

# Fitting the retriever to the list of documents in the dataframe
cdqa_pipeline.fit_retriever(df=data_frame)

query = 'how do i book an appointment ?'
prediction = cdqa_pipeline.predict(query=query)

print('query: {}\n'.format(query))
print('answer: {}\n'.format(prediction[0]))
print('title: {}\n'.format(prediction[1]))
print('paragraph: {}\n'.format(prediction[2]))