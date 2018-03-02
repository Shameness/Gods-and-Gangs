a = {klm=3,imm=5}

b = {}
b[1] = a
c = {}
c[2] = a
print(b[1],c[2], a)

b[1].klm = 17
print(c[2].klm)
