import gui
import sys
from db import DB
import organizer

def main() :
    dbname = "sgs"
    user = "postgres"
    pwd = ""
    d = DB(dbname, user, pwd)

    dataDict = {"ssn":5, "name_surname":'Tolkein', "member":True, "birth_date":'1985-05-04', "communication_info":'antalya'}
    d.insertData('shooter',dataDict)
    rows = d.getView("shooter_ob_name")
    print(rows)

if (__name__ == '__main__') :
    main()