import matplotlib.pyplot as plt
import math

filename = 'FPGA_project\diagram\stp1_auto_signaltap_1.txt'

y = []

with open(filename, 'r', encoding='utf-8') as f:
    line = f.readlines()[18:]
    x = range(1, len(line)+1, 1)
    for i in range(len(line)):
        n = line[i].split()[1]
        y.append(int(n))
print("Done!")
plt.plot(x, y)

plt.show()