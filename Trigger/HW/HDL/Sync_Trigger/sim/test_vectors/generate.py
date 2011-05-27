import os.path
import random
import numpy

tid_us = 1000
f_mhz = 1
iterasjoner = tid_us*f_mhz

prob_noise = 0.01
prob_event = 0.1
filename  = "vectors.dat"
filename2  = "constants.vhd"
path = "../../../Shared/"
random.seed()



done = False

def find_int_after_text(txt):
    FILE = open(path+filename2, "r")
    text = FILE.read()

    isint = False
    index = text.find(txt)
    i=12
    while not isint:
        ret_value = text[index+i]
        next_char = text[index+i+1]
        if ret_value.isdigit():
            if text[index+i+1].isdigit():
                ret_value = ret_value + text[index+i+1]
            isint = True
        else:
            i=i+1
    FILE.close()
    return ret_value


no_rocs = int(find_int_after_text("NUMBER_OF_ROCS"))
no_modules = int(find_int_after_text("NUMBER_OF_MODULES"))



module1 = int(find_int_after_text("ROCS_IN_M1"))
module2 = int(find_int_after_text("ROCS_IN_M2"))
module3 = int(find_int_after_text("ROCS_IN_M3"))
module4 = int(find_int_after_text("ROCS_IN_M4"))

##no_rocs = 15
##no_modules = 3
##
##
##
##module1 = 5
##module2 = 5
##module3 = 5
##module4 = 0



modules = [module1, module2, module3, module4]

    
def get_vec():
    rand_num1 = random.random()
    rand_num2 = random.random()
    vec1 = numpy.zeros([2,no_rocs], int)
    vec2 = numpy.zeros([2,no_rocs], int)
    ret_vec2 = numpy.zeros([2,no_rocs], int)
    ret_vec1 = numpy.zeros([2,no_rocs], int)
    if rand_num1 < prob_noise:
        ret_vec1 = get_noise()
    if rand_num2 < prob_event:
        ret_vec2 = get_event()

    ret_vec2 = ret_vec1+ret_vec2

    for a in range(0,2):
        for b in range(0, no_rocs):
            if ret_vec2[a][b] == 2:
                ret_vec2[a][b] = 1


            
    return ret_vec2


def get_noise():
    rand_num1 = random.random()
    
    ret_vec = numpy.zeros([2,no_rocs], int)
    
    step = 1/float(no_rocs)
    var = 0

    n = 1
    var = n*step
    while var < rand_num1:
        n = n+1
        var = n*step
        

    ret_vec[0][int(n)-1] = 1
    return ret_vec
    
def get_event():
    mod_placement = [-1]*2
    roc_placement = [-1]*2
    ret_vec = numpy.zeros([2,no_rocs], int)

    done = False
    while not done:
        mod_placement[0] = random.randrange(0, no_modules, 1)
        mod_placement[1] = random.randrange(0, no_modules, 1)
        if mod_placement[0] != mod_placement[1]:
            done = True


    ##finding the range:
    for b in range(0,2):
        n1 = 0
        n2 = 0
        for a in range(0,mod_placement[b]):
            n1 += modules[a]
        n2 = n1 + modules[mod_placement[b]]
        roc_placement[b] = random.randrange(n1,n2+1,1)


    
    ##roc_placement[0] = random.randrange(modules[mod_placement[0]],modules[mod_placement[0]-1]-modules[mod_placement[0]]+1, 1)
    ##roc_placement[1] = random.randrange(modules[mod_placement[1]],modules[mod_placement[1]-1]-modules[mod_placement[1]]+1, 1)
    
    if random.random() > 0.5:
        ret_vec[0][roc_placement[0]-1]= 1
        ret_vec[0][roc_placement[1]-1]= 1
    else:
        ret_vec[0][roc_placement[0]-1]= 1
        ret_vec[1][roc_placement[1]-1]= 1

    
    return ret_vec
            
   


vectorlist = []
iterator = 0



for count in range(0,iterasjoner):
    vec = get_vec()
    for a in range(0,2):
        for b in range(0, no_rocs):
            vectorlist.append(str(vec[a][b]))
        vectorlist.append('\n')



FILE = open(filename, "w")
FILE.writelines(vectorlist)
FILE.close()

    
