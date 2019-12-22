import requests as req
from bs4 import BeautifulSoup

MAX_PAGE = 8
BASE_URL = 'https://www.stickpng.com'
SEARCH_BASE_URL = BASE_URL + '/cat/at-the-movies/cartoons/ben-10?page={}'
ALIENS_FOLDER = './aliens/'


def download_file(url, file_name):
    local_filename = url.split('/')[-1]
    ext = local_filename.split('.')[-1]
    fl = ALIENS_FOLDER + file_name + f'.{ext}'
    # NOTE the stream=True parameter below
    with req.get(url, stream=True) as r:
        r.raise_for_status()
        with open(fl, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                if chunk:  # filter out keep-alive new chunks
                    f.write(chunk)
                    # f.flush()
    return fl


def get_arr_of_aliens():
    aliens = []
    for page in range(1, MAX_PAGE + 1):
        soup = BeautifulSoup(
            req.get(url=SEARCH_BASE_URL.format(page)).text, 'html.parser')
        search = soup.select('#results .item')
        for s in search:
            aliens.append({
                'alien': s.select_one('.title').text.replace('Ben 10', '').replace(' ', '_').lower(),
                'url': BASE_URL + s.select_one('.image img')['src'].replace('thumgs', 'images')
            })

    return aliens


aliens = get_arr_of_aliens()

for alien in aliens:
    download_file(alien['url'], alien['alien'])

print('Done')
