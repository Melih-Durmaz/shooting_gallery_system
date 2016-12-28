from db import DB
from PyQt4.QtGui import *
class ORG:
    def __init__(self, db):
        self._db = db

        self._shooterlabels = ("SSN", "Name Surname", "Birth Date", "Communication Info", "Member", "Shot Success", "Shot Count",)
        self._fieldlabels = ("ID", "Name", "Location", "Max Range", "Throng",)
        self._guntypelabels = ("ID", "Name", "Ammo Percentage",)
        self._gunlabels = ("ID", "Serial Number", "Name", "Gun Type",)
        self._shotlabels = ("Shooter", "Gun", "Field", "Success Percentage", "Starts At", "Ends At",)

        self._shootercols = ("ssn", "name_surname", "birth_date", "communication_info", "member",)
        self._fieldcols = ("nm", "lctn", "max_range",)
        self._schedulecols = ("field_id", "start", "stop",)
        self._guntypecols = ("nm",)
        self._usesfieldcols = ("gun_type_id", "field_id",)
        self._guncols = ("serial_number", "nm", "gun_type_id",)
        self._shotcols = ("shooter_ssn", "gun_id", "field_id", "success_percentage", "start_date", "stop_date",)

    def getTable(self,tableName,param=None):
        if "shooter" in tableName:
            labels = self._shooterlabels
        elif "field" in tableName:
            labels = self._fieldlabels
        elif "gun_type" in tableName:
            labels = self._guntypelabels
        elif "gun" in tableName:
            labels = self._gunlabels
        elif "shot" in tableName:
            labels = self._shotlabels

        table = QTableWidget()

        if param == None :
            try :
                tableData = self._db.getView(tableName)
            except Exception as e:
                raise e
            table.setRowCount(len(tableData))
            table.setColumnCount(len(tableData[0]))
            table.setHorizontalHeaderLabels(labels)

            for i in range(len(tableData)) :
                for j in range(len(tableData[i])) :
                    table.setItem(i,j, QTableWidgetItem(str(tableData[i][j])))

        return table

    def getCombo(self,comboName, ret, param=None):
        if param==None :
            try :
                comboData = self._db.getView(comboName)
            except Exception as e:
                raise e
        else :
            if "gun_combo"==comboName:
                try :
                    comboData = self._db.runFunc("get_guns_from_field", param)
                except Exception as e:
                    raise e
            elif "field_combo"==comboName:
                try :
                    comboData = self._db.runFunc("get_fields_from_gun", param)
                except Exception as e:
                    raise e
        combo = QComboBox()
        for i in range(len(comboData)):
            ret.append(comboData[i][0])
            combo.addItem(comboData[i][1])
        return combo

    def addItem(self,tableName,param):
        ret = None
        if "shooter" in tableName:
            if len(param) != 5 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._shootercols
        elif "field" in tableName:
            if len(param) != 3 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._fieldcols
        elif "gun_type" in tableName:
            if len(param) != 1 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._guntypecols
        elif "gun" in tableName:
            if len(param) != 3 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._guncols
        elif "shot" in tableName:
            if len(param) != 6 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._shotcols
        elif "schedule" in tableName:
            if len(param) != 3 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._schedulecols
        elif "uses_field" in tableName:
            if len(param) != 2 :
                raise Exception('You missed some parameters for inserting.')
            cols = self._usesfieldcols

        dict = {}
        for i in range(len(cols)) :
            dict[cols[i]] = param[i]

        try :
            self._db.insertData(tableName,dict)
        except Exception as e:
            raise e

    def delItem(self,tableName,param):
        if "shooter" in tableName:
            col = "ssn"
        else :
            col = "id"

        dict = {col:param}
        try:
            self._db.deleteData(tableName, dict)
        except Exception as e:
            raise e

