
import time
a='Sun 10 May 2015 13:54:36 -0700' #Fri 01 May 2015 13:54:36 +0000 Sat 02 May 2015 19:54:36 +0530
b='Sun 10 May 2015 13:54:36 -0000' 
tza=a.split(' ')
tzb=b.split(' ')
x=int(tza[5])
y=int(tzb[5])
hra=int(x/100)
mna=x%100
hrb=int(y/100) 
mnb=y%100
anew=time.strptime(a[:24],"%a %d %b %Y %H:%M:%S")
bnew=time.strptime(b[:24],"%a %d %b %Y %H:%M:%S")
t1=time.mktime(anew)
t2=time.mktime(bnew)
if x>=0:
    t1=t1-(hra*3600+mna*60)
else:
    t1=t1+(hra*3600+mna*60)
if y>=0:
    t2=t2-(hrb*3600+mnb*60)
else:
    t2=t2+(hrb*3600+mnb*60)
print (abs(t1-t2))