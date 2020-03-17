from deeppavlov import configs, train_model

from deeppavlov.core.common.file import read_json

model_config = read_json(configs.faq.tfidf_logreg_en_faq)

faq = train_model('./tfidf_logreg_en_faq.json')

a = faq(["is zeamed safe to use  ?"])

print('ans => ',a[0])