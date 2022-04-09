with open('asm.txt', 'r') as f:
    les_lignes = f.readlines()

r = []
instructions = []

for ligne in les_lignes:
    l = ligne.strip().split(' ')
    instructions.append(l)

i = 0
while i < len(instructions):
    
    asm = instructions[i]
    
    #ADD (1)
    if asm[0] == '1':
        r[asm[1]] = r[asm[2]] + r[asm[3]]
    
    #MUL (2)
    elif asm[0] == '2':
        r[asm[1]] = r[asm[2]] * r[asm[3]]

    #SOU (3)
    elif asm[0] == '3':
        r[asm[1]] = r[asm[2]] - r[asm[3]]
    
    #DIV (4)
    elif asm[0] == '4':
        r[asm[1]] = r[asm[2]] / r[asm[3]]
    
    #COP (5)
    elif asm[0] == '5':
        r[asm[1]] = r[asm[2]]
    
    #AFC (6)
    elif asm[0] == '6':
        r[asm[1]] = asm[2]
    
    #JMP (7)
    elif asm[0] == '7':
        i = asm[1]
    
    #JMF (8)
    elif asm[0] == '8':
        if not r[asm[1]]:
            i = asm[2]
            
    #INF (9)
    elif asm[0] == '9':
        if r[asm[2]] < r[asm[3]]:
            r[asm[1]] = 1
        else:
            r[asm[1]] = 0
    
    #SUP (A)
    elif asm[0] == 'A':
        if r[asm[2]] > r[asm[3]]:
            r[asm[1]] = 1
        else:
            r[asm[1]] = 0
    
    #EQU (B)
    elif asm[0] == 'B':
        if r[asm[2]] == r[asm[3]]:
            r[asm[1]] = 1
        else:
            r[asm[1]] = 0
    
    #PRI (C)
    elif asm[0] == 'C':
        print(r[asm[1]])
    
    i += 1