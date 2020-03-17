

from deeppavlov import configs
from deeppavlov.core.common.file import read_json
from deeppavlov.core.commands.infer import build_model

faq = build_model(configs.faq.tfidf_logreg_en_faq, download = True)
a = faq(["I need help"])

print('ans => ',a)

