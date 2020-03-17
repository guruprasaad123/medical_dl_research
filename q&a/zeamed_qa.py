from deeppavlov import configs, train_model
from os import path
from collections import OrderedDict

from deeppavlov.core.common.file import read_json

CONFIG_PATH = 'configs'
CONFIG_FILE = 'fasttext_tfidf_autofaq.json'
FILE_CONFIG = {
    "class_name": "faq_reader",
    "x_col_name": "Question",
    "y_col_name": "Answer",
    "data_url": "./data/zeamed-web/zeamed-faq.csv"
  }

model_config = read_json(configs.faq.tfidf_logreg_en_faq)

model_config = read_json(   path.join(CONFIG_PATH,CONFIG_FILE)  )

# print(model_config['dataset_reader'])

model_config['dataset_reader'] = OrderedDict(FILE_CONFIG)

# print(model_config['dataset_reader'])


faq = train_model(model_config)

a = faq(["hand is ? "])

print('ans => ',a)