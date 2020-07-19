import requests

url = 'https://questionablecontent.net/comics/'

for i in range(1,10):
    url_c = url + str(i) + '.png'
    arq_name = 'image' + str(i) + '.png'

    r = requests.get(url_c)
    
    if r.status_code == 200:
        with open(arq_name, 'wb') as f:
            f.write(r.content)