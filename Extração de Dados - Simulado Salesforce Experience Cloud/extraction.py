# Coleta questões e alternativas do simulado da Certificação Salesforce Experience Cloud 
# Consultant do Site www.freecram.net e cria um csv

# Import de bibliotecas
import csv
import requests
from bs4 import BeautifulSoup

questionsList      = []
alternativesList   = []
correctAnswersList = []

primaryURL = 'https://www.freecram.net'
URLArray = ['https://www.freecram.net/question/Salesforce.Experience-Cloud-Consultant.v2022-04-08.q57/the-mission-of-no-more-homelessness-nmh-is-to-help-every-homeless-person-in-the-best-possible-manner']

for currentURL in URLArray:

    # Request da página
    response = requests.get(currentURL)
    html     = response.content.decode()

    # Criar objeto Beautiful Soup
    bs = BeautifulSoup(html, 'html.parser')

    # Questão
    question = bs.find('div', class_='qa-question')
    questionsList.append(question.contents[0])

    # Alternativas
    parentAlternatives = bs.find('div', class_='qa-options')
    alternatives       = parentAlternatives.find_all('label')

    tempAlt = []

    for alt in alternatives:
        tempAlt.append(alt.contents[1].string + ' ' + alt.contents[2].strip())
    
    alternativesList.append(tempAlt)

    # Alternativa(s) correta(s)
    parentDiv     = bs.find('div', class_='qa-answerexp')
    correctAnswer = parentDiv.find('span')
    correctAnswersList.append(correctAnswer.string)

    # Armazena link da proxima questão
    hrefs = bs.find_all('a',class_='btn btn-sm btn-success')
    
    if(len(hrefs) > 1):
         URLArray.append(primaryURL + hrefs[1]['href'])
    
    elif(len(hrefs) == 1 and len(URLArray) == 1):
         URLArray.append(primaryURL + hrefs[0]['href'])


# Cabeçalho do arquivo .csv
c = csv.writer(open("./Extração de Dados - Simulado Salesforce Experience Cloud/ExperienceCloud.csv", "a", encoding="utf-8", newline=""))
c.writerow(["#","Questão","Alternativas", "Alternativa(s) Correta(s)"])

for i in range(len(questionsList)):
    
    # Escreve questão
    c.writerow([(i+1), questionsList[i]])

    # Escreve alternativas e resposta correta
    for j in range(len(alternativesList[i])):

        if(j == 0):
            c.writerow(["","",alternativesList[i][j], correctAnswersList[i]])
        else:
            c.writerow(["","",alternativesList[i][j]])

    # Pula uma linha
    c.writerow([])




    

