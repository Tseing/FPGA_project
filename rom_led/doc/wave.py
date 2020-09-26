import math
import numpy as np

txt_file = open(r"FPGA_project\rom_led\doc\wave.txt", "w")

step = 2*math.pi/2**14
j = 0

for i in np.arange(0, 2*math.pi, step):
    dict = {'0':'1000',
            '1':'0100',
            '2':'0010',
            '3':'0001'}
    print("\t\t", j, "\t:\t"+dict[str(int(round(1.5*math.cos(i)+1.5)))]+ ";", file=txt_file)
    j = j + 1

txt_file.close()