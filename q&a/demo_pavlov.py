from deeppavlov import build_model, configs
from pandas import DataFrame , read_csv
from nltk.tokenize import sent_tokenize

# def get_sentences(values=[]):
#   sentences = ""
#   for value in values:
#     tokens = sent_tokenize(value)
#     print('tokens => ',tokens)
#     sentences += tokens[0]
#   return sentences

# df = read_csv('./data/zeamed-web/answers.csv',index_col=False,usecols=[1,2,3])

# sentences = get_sentences(df['content'].values)

# print(sentences)

model_qa = build_model(configs.squad.squad_bert, download=True)

ans = model_qa(['ZeaMed is a popular online price and quality transparency platform that helps consumers to shop for healthcare services like MRI, ultrasound, doctors visits etc and it let Consumers search for doctors and hospitals in nearby location, search tests, schedule appointments, read other patient reviews, and also rate the providers and they can book appointments from anywhere and anytime as it is free to use. Our aim is to bring transparency in healthcare prices and help everyone to get the best price and our service is also free for our customers. Zeamed provides 24/7 customer service to their consumers. you can find the zeamed doctor profile on this app by Selecting the test name and location and click on search. Once the list of providers appear,click on any provider(doctor) to view their profile.  patient information/data is secured as per Zeamed terms and conditions. ZeaMed’s users are anyone who is willing to save money on healthcare services. Our most frequent users are uninsured, underinsured, people with high deductible health plans (HDDP), visitors, students, etc. At this time, we do not accept patients who have government purchased insurances like Medicare and Medicaid.  Zeamed provides innumerable doctors for its patients. So, patients can book an appointment as per their convenience. And there are no additional features that are supported on this app. you can install zeamed app for consumer by typing zeamed in playstore/appstore and if you want zeamed app for doctors you can find by typing zeamed pro in playstore/appstore. ZeaMed encourages all its customers to be there on time cause they honor the appointment timings and be serious about it , but we understand. You can call and let the office know that you will be late. you dont need to show your zeamed appointment ID when visiting a clinic/hospital for your appointment. it may be possible that some of the doctors/clinics/hospitals may not be listed in zeamed or zeamed.com. Hence, we kindly request you to choose among the available doctors/clinics/hospitals. We are adding providers who are willing to share their cash prices. Zeamed healthcare is a trademark for safety. The ZeaMed customer service agent will assist you when you have issues with scheduling. Patient has an option to reschedule/cancel the appointment as per his/her convenience. They can visit Zeamed website and search test or test location and then you can book as per the search entity. A person cannot book 2 appointments at the same time on the same day. ZeaMed is only available in English. If a specific reason for visit isn’t listed then patients can contact ZeaMed healthcare customer care. It is recommended you use the latest versions of Google Chrome, Mozilla Firefox or Safari. The scheduling feature is compatible with Internet Explorer 11.'],
['Some doctors/clinics/hospitals in my area are not listed on zeamed ?'])

print('ans => ',ans)
