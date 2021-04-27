from skimage import io
import random
import numpy as np
 
def salt_and_pepper_noise(img, proportion=0.05):
    noise_img =img
    height,width =noise_img.shape[0],noise_img.shape[1]
    num = int(height*width*proportion)#多少个像素点添加椒盐噪声
    for i in range(num):
        w = random.randint(0,width-1)
        h = random.randint(0,height-1)
        if random.randint(0,1) ==0:
            noise_img[h,w] =0
        else:
            noise_img[h,w] = 255
    return noise_img
if __name__ == '__main__':
    img =io.imread(r"mtest.png")
    noise_img = salt_and_pepper_noise(img,0.25)
    io.imshow(noise_img)
    io.show()
    io.imsave('jiaoyan_'+'mtest.png', noise_img)
