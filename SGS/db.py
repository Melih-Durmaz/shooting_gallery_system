import psycopg2

class DB() :
    def __init__(self, dbname, user, pwd, host="localhost", port="5432"):
        self._dbname = dbname
        self._user = user
        self._pwd = pwd
        self._host = host
        self._port = port

    def connect(self):
        return psycopg2._connect("dbname='"+self._dbname+"' user='"+self._user+"' password='"+self._pwd+"' host='"+self._host+"' port='"+self._port+"'")

    def getView(self, viewName):
        conn = self.connect()
        cur = conn.cursor()
        cur.execute("select * from " + viewName)
        rows = cur.fetchall()
        conn.close()
        return rows

    def insertData(self, tableName, dataDict) :
        keys = dataDict.keys()
        values = []
        for key in keys:
            if type(dataDict[key]) is str :
                    values.append("'" + str(dataDict[key]) + "'")
            else :
                values.append(str(dataDict[key]))

        print(values)

        conn = self.connect()
        cur = conn.cursor()
        cur.execute("insert into " + tableName + "(" + ','.join(keys) + ") values (" + ','.join(values) + ")")
        conn.commit()
        conn.close()

    def deleteData(self, tableName, conditionDict):
        condition = []
        for key in conditionDict.keys() :
            if type(conditionDict[key]) is str :
                condition.append(key + " = '" + conditionDict[key] + "'")
            else :
                condition.append(key + " = " + conditionDict[key])
        conn = self.connect()
        cur = conn.cursor()
        cur.execute("delete from " + tableName + " where " + ' and '.join(condition))
        conn.commit()
        conn.close()

    def runFunc(self, funcName, paramLst):
        for i in range(len(paramLst)) :
            if type(paramLst[i]) is str :
                paramLst[i] = "'" + paramLst[i] + "'"
            paramLst[i] = str(paramLst[i])
        conn = self.connect()
        cur = conn.cursor()
        cur.execute("select " + funcName + "(" + ','.join(paramLst) + ")")
        rows = cur.fetchall()
        conn.close()
        return rows