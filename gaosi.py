from skimage import io
import random
import numpy as np

'''三通道
def gauss_noise(image,sigma = 10):
    img = image.astype(np.int16)#此步是为了避免像素点小于0，大于255的情况
    mu =0
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            for k in range(img.shape[2]):
                img[i,j,k] = img[i,j,k] +random.gauss(mu=mu,sigma=sigma)
    img[img>255] = 255
    img[img<0] = 0
    img = img.astype(np.uint8)
    return img

'''
def gauss_noise(image,sigma = 10):
    img = image.astype(np.int16)#此步是为了避免像素点小于0，大于255的情况
    mu =0
    for i in range(img.shape[0]):
        for j in range(img.shape[1]):
            img[i,j] = img[i,j] +random.gauss(mu=mu,sigma=sigma)
                
    img[img>255] = 255
    img[img<0] = 0
    img = img.astype(np.uint8)
    return img

 
if __name__ == '__main__':
    img =io.imread(r"mtest.png")
    # noise_img = salt_and_pepper_noise(img)
    gauss_img = gauss_noise(img,50)
    io.imshow(gauss_img)
    io.show()
    io.imsave('gaosi_'+'mtest.png', gauss_img)
