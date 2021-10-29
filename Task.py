NoOfTestCase = int(input())
ls = []
for i in range(NoOfTestCase):
    n,m = input().split(" ")
    n = int(n)
    m = int(m)
    maxBorder = 0
    for j in range(n):
        row = input()
        count = row.count("#")
        if count > maxBorder:
            maxBorder = count
    ls.append(maxBorder)

for x in ls:
    print(x)        
