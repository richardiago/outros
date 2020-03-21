# Import de bibliotecas
import csv
import requests
from bs4 import BeautifulSoup

# Páginas
url = ['./Paginas/pag1.html', './Paginas/pag2.html', './Paginas/pag3.html', './Paginas/pag4.html', './Paginas/pag5.html', './Paginas/pag6.html'] 

# Cabeçalho do arquivo .csv
c = csv.writer(open("quiz.csv", "a", encoding="utf-8"))
c.writerow(["ID", "Difficulty", "Question", "A", "B", "C", "D", "E", "Type"])
l = []
n = 0
t = "CHECKBOX"


# Scrapping das páginas
for link in url:

    # Criar objeto Beautiful Soup
    bs = BeautifulSoup(open(link, encoding="utf-8"), 'lxml')

    # Filtrar dificuldade, questões, alternativas e tipo, pelas classes HTML
    text = bs.find_all('span', {'class': ['diff_span', 'question_text 1', 'labelNormal', 'smallContent']})

    for i in text:

        # A cada 'diff_span' -> add linha no csv
        if("diff_span" in str(i)):
            l.append(t)

            # Caso for o primeiro diff_span
            if (len(l)==1):
                del(l)
                l = []
            
            elif(len(l) == 6):
                l.append('')
            

            c.writerow(l)
            del(l)
            n +=1
            l = []
            l.append(n)
            l.append((i.text)[11:])


        #Questão e alternativas
        elif ("question_text 1" in str(i) or "labelNormal"  in str(i)):

            if ("(Missed)" in str(i)):
                l.append(i.text[:-9])
            else:
                l.append(i.text)


        #Type
        elif("smallContent" in str(i)):
            
            t = "CHECKBOX"

        



        
    
    





    