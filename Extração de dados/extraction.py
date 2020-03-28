# Coleta questões e outras informações do site proprofs.com e salva em um arquivo csv

# Import de bibliotecas
import csv
import requests
from bs4 import BeautifulSoup

# Páginas (armazenadas localmente)
url = ['./Paginas/pag1.html', './Paginas/pag2.html', './Paginas/pag3.html',
       './Paginas/pag4.html', './Paginas/pag5.html', './Paginas/pag6.html']

# Cabeçalho do arquivo .csv
c = csv.writer(open("quiz.csv", "a", encoding="utf-8", newline=""))
c.writerow(["ID", "Difficulty", "Question", "A",
            "B", "C", "D", "E", "Type", "Group"])

# Variáveis auxiliares
l = []              # Armazena linhas do csv
n = 0               # Conta linhas do csv
t = "CHOICE"        # Captura tipo de pergunta


# Scraping das páginas
for link in url:

    # Criar objeto Beautiful Soup
    bs = BeautifulSoup(open(link, encoding="utf-8"), 'lxml')

    # Filtrar dificuldade, questões, alternativas e tipo, pelas classes HTML
    text = bs.find_all(
        'span', {'class': ['diff_span', 'question_text 1', 'labelNormal', 'smallContent']})

    for i in text:

        # A cada 'diff_span' -> add linha no csv
        if("diff_span" in str(i)):

            if(len(l) == 7):
                l.append(" ")

            l.append(t)
            l.append("Marketing Cloud")
            t = "CHOICE"

            # Caso for o primeiro diff_span
            if (len(l) == 2):
                #del(l)
                l = []

            # Escreve a linha no csv
            if len(l) != 0:
                c.writerow(l)
            #del(l)
            n += 1
            l = []
            l.append(n)
            l.append((i.text)[11:])

        # Questão e alternativas
        elif ("question_text 1" in str(i) or "labelNormal" in str(i)):

            # Retira "(Missed)" caso esteja presente
            if ("(Missed)" in str(i)):
                l.append(i.text[:-9].replace('\t', '').replace('\n', ''))
    
            else:
                l.append(i.text.replace('\t', '').replace('\n', ''))
                
        # Verifica tipo da questão
        elif("smallContent" in str(i)):

            t = "CHECKBOX"
