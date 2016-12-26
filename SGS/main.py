from gui import GUI
import sys
from db import DB
from org import ORG



def main() :
    dbname = "sgs"
    user = "postgres"
    pwd = ""

    d = DB(dbname, user, pwd)
    o = ORG(d)
    g = GUI(sys.argv, o)

    #g.mainWindow.show()
    #sys.exit(g.exec_())

    data = [2,3,3, 75.5, '2016-12-28 00:00:00.000000', '2016-12-28 02:00:00.000000']
    try :
        o.addItem('shot',data)
    except Exception as e :
        print (e.message)

if (__name__ == '__main__') :
    main()