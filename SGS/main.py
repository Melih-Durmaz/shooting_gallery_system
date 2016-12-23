from gui import GUI
import sys
from db import DB
from org import ORG

def main() :

    dbname = "sgs"
    user = "postgres"
    pwd = "43951515"

    d = DB(dbname, user, pwd)
    o = ORG(d)
    g = GUI(sys.argv, o)

    g.mainWindow.show()
    sys.exit(g.exec_())


if (__name__ == '__main__') :
    main()