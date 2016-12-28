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
        try :
            cur.execute("select * from " + viewName)
        except psycopg2.Error as e:
            conn.close()
            raise e
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

        query = "insert into " + tableName + "(" + ','.join(keys) + ") values (" + ','.join(values) + ")"

        conn = self.connect()
        cur = conn.cursor()
        try :
            cur.execute(query)
        except psycopg2.InternalError as e:
            conn.close()
            raise e

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
        try:
            cur.execute("delete from " + tableName + " where " + ' and '.join(condition))
        except psycopg2.Error as e:
            conn.close()
            raise e
        conn.commit()
        conn.close()

    def runFunc(self, funcName, paramLst):
        for i in range(len(paramLst)) :
            if type(paramLst[i]) is str :
                paramLst[i] = "'" + paramLst[i] + "'"
            paramLst[i] = str(paramLst[i])
        conn = self.connect()
        cur = conn.cursor()
        query = "select " + funcName + "(" + ','.join(paramLst) + ")"
        try:
            cur.execute(query)
        except psycopg2.InternalError as e:
            conn.close()
            raise e
        rows = cur.fetchall()
        rows[0] = rows[0][0][1:-1].split(',')
        conn.close()
        return rows

    def runQuery(self, query):
        conn = self.connect()
        cur = conn.cursor()
        try:
            cur.execute(query)
        except psycopg2.Error as e:
            conn.close()
            raise e
        if 'select' in query :
            rows = cur.fetchall
            conn.close()
            return rows