
structs = {}
unions = {}
enums = {}
with open("types.h") as header:
    curType = None
    curRecords = []
    nonempty = False
    curParse = None
    enum = False
    for line in header:
        sline = line.strip()
        if sline.startswith("struct"):
            if sline.endswith('{'):
                sline = sline[:-1]
            curType = sline.split()[1].lower()
            curRecords = []
            curParse = structs
        elif sline.startswith("union"):
            if sline.endswith('{'):
                sline = sline[:-1]
            curType = sline.split()[1].lower()
            curRecords = []
            curParse = unions
        elif sline.startswith("enum"):
            if sline.endswith('{'):
                sline = sline[:-1]
            curType = sline.split()[1].lower()
            curRecords = []
            enum = True
            curParse = enums
        elif sline == '};':
            curParse[curType] = curRecords
            curParse = None
            enum = False
            curRecords = None
            curType = None
            nonempty = False
        elif sline == '// Nonempty':
            nonempty = True
        elif sline == '{' or sline == '' or sline.startswith('//'):
            continue
        elif enum:
            name = sline.split(';')[0]
            curRecords.append(name)
        else:
            tType, name = sline.split()[:2]
            if nonempty:
                if tType.endswith('[]'):
                    tType = tType[:-2]+'[ne]'
                nonempty = False
            curRecords.append((name[:-1], tType.lower()))

print('% General')
print('any_type(_).')
print('any_list([]).')
print('any_list([_|_]).')
print('any_list_ne([_|_]).')
print('\n')

print('% Structs')
for n, ts in structs.items():
    res = n+'('
    for rn, t in ts:
        res += rn + ','
    res = res[:-1]+') :-'
    ver = res[:-3]
    ver = n+'_type(X) :- X='+ver+', '+ver + '.\n'
    res = ver + res
    for rn, t in ts:
        if t == 'any':
            continue
        if t.endswith('[]'):
            t = t[:-2]
            res += '\n    '+t+'_list('+rn+'),'
        elif t.endswith('[ne]'):
            t = t[:-4]
            res += '\n    '+t+'_list_ne('+rn+'),'
        else:
            res += '\n    '+t+'_type('+rn +'),'
    res = res[:-1] + '.\n'
    res += n+'_list([]).\n'+n+'_list([H|T]) :- '+n+'_type(H), '+n+'_list(T).\n'
    res += n+'_list_ne([H]) :- ' +n+'_type(H).\n'+n+'_list_ne([H|T]) :- '+n+'_type(H), '+n+'_list_ne(T).\n'
    print(res)

print('\n% Unions')
for n, ts in unions.items():
    res = ''
    for rn, t in ts:
        res += n+'_type(X) :- ' + t + '_type(X).\n'
    res += n+'_list([]).\n'+n+'_list([H|T]) :- '+n+'_type(H), '+n+'_list(T).\n'
    res += n+'_list_ne([H]) :- ' +n+'_type(H).\n'+n+'_list_ne([H|T]) :- '+n+'_type(H), '+n+'_list_ne(T).\n'
    print(res)

print('\n% Enums')
for n, ts in enums.items():
    res = ''
    for rn in ts:
        res += n+"_type('"+rn+"').\n"
    res += n+'_list([]).\n'+n+'_list([H|T]) :- '+n+'_type(H), '+n+'_list(T).\n'
    res += n+'_list_ne([H]) :- ' +n+'_type(H).\n'+n+'_list_ne([H|T]) :- '+n+'_type(H), '+n+'_list_ne(T).\n'
    print(res)
