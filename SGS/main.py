from gui import GUI
import sys
from db import DB
from org import ORG

class A:
    def __init__(self):
        print ("i am A")

    def throw(self):
        raise Exception('catch me if you can')

def main() :

    a = A()
    try:
        a.throw()
    except Exception as e:
        print ('I caught you : ' + repr(e))

'''
    dbname = "sgs"
    user = "postgres"
    pwd = "43951515"

    d = DB(dbname, user, pwd)
    o = ORG(d)
    g = GUI(sys.argv, o)

    g.mainWindow.show()
    sys.exit(g.exec_())
'''

if (__name__ == '__main__') :
    main()