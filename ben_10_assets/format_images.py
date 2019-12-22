import cv2
import matplotlib.pyplot as plt
import os
BASE_FOLDER = './aliens/'

aliens = './omni_aliens2/'
masks = './omni_aliens_masks2/'

code = [29, 118, 9, 255]


def remove_first_underscore():
    for f in os.listdir(BASE_FOLDER):
        if f[0] == '_':
            os.rename(BASE_FOLDER+f, BASE_FOLDER+f[1:])


def omni_img(filename):
    img = cv2.imread(BASE_FOLDER + filename, cv2.IMREAD_UNCHANGED)
    trans_mask = img[:, :, 3] == 0
    img[trans_mask] = code
    img = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
    cv2.imwrite(aliens + filename, img)


def omni_img_mask(filename):
    img = cv2.imread(BASE_FOLDER + filename, cv2.IMREAD_UNCHANGED)
    trans_mask = img[:, :, 3] == 0
    img[~trans_mask] = code

    img = cv2.cvtColor(img, cv2.COLOR_RGB2RGBA)
    cv2.imwrite(masks + 'mask_'+filename, img)


def omni_img_mask_backup(filename):
    img = cv2.imread(BASE_FOLDER + filename, cv2.IMREAD_UNCHANGED)
    trans_mask = img[:, :, 3] == 0
    img[:] = 0
    img[trans_mask] = code
    img = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
    cv2.imwrite(masks + 'mask_'+filename, img)


def gen_files():
    files = os.listdir(BASE_FOLDER)
    files.remove('.DS_Store')
    counter = len(files)
    for f in files:
        # print(counter)
        # omni_img(f)
        # omni_img_mask(f)
        counter -= 1
    print('Done')


gen_files()
