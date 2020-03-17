from nltk.tokenize import sent_tokenize
from pandas import DataFrame

from cdqa.utils.filters import filter_paragraphs
from cdqa.utils.download import download_model, download_bnpp_data
from cdqa.pipeline.cdqa_sklearn import QAPipeline

paragraph = "At North Alabama Medical Center, we are committed to balancing clinical excellence with safe, high-quality, compassionate care for our patients.  We set aggressive quality standards, striving to exceed state and national benchmarks in the areas of clinical quality, patient safety and customer service. As we set the bar high and raise it again and again, we are regularly recognized for our commitment to quality and safety, exceptional advanced care and leading outcomes. Physicians, nurses and staff are focused on continually improving patient safety and the quality of care by adopting best practices, confirmed by research to improve patient outcomes. NAMC is accredited by The Joint Commission, an independent not-for-profit organization that evaluates and accredits health care organizations and programs."

sentences = sent_tokenize(paragraph)

print(sentences)

obj = {'title':'north alabama medical center','paragraphs':[sentences]}
df = DataFrame(data=obj)

#df = filter_paragraphs(df)

#print('dataframe => ',df)

cdqa_pipeline = QAPipeline(reader='models/bert_qa.joblib')

# Fitting the retriever to the list of documents in the dataframe
cdqa_pipeline.fit_retriever(df=df)

query = 'what is NAMC accredited by ?'
prediction = cdqa_pipeline.predict(query=query)

print('query: {}\n'.format(query))
print('answer: {}\n'.format(prediction[0]))
print('title: {}\n'.format(prediction[1]))
print('paragraph: {}\n'.format(prediction[2]))