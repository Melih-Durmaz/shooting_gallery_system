import psycopg2

class DB() :
    def __init__(self, dbname, user, pwd, host="localhost", port="5432"):
        self._dbname = dbname
        self._user = user
        self._pwd = pwd
        self._host = host
        self._port = port

    def connect(self):
        return psycopg2._connect(self._dbname, self._user, self._pwd, self._host, self._port)

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
            if isinstance(key, str) :
                values.append("'" + dataDict[key] + "'")
            else :
                values.append(dataDict[key])

        conn = self.connect()
        cur = conn.cursor()
        cur.execute("insert into " + tableName + "(" + ','.join(keys) + ") values (" + ','.join(values) + ")")
        conn.commit()
        conn.close()

    def deleteData(self, tableName, conditionDict):
        condition = []
        for key in conditionDict.keys() :
            if isinstance(conditionDict[key], str) :
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
            if isinstance(paramLst[i], str) :
                paramLst[i] = "'" + paramLst[i] + "'"
        conn = self.connect()
        cur = conn.cursor()
        cur.execute("select " + funcName + "(" + ','.join(paramLst) + ")")
        rows = cur.fetchall()
        conn.close()
        return rows