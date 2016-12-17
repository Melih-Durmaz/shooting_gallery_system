from PyQt4.QtGui import *


class GUI(QApplication):
    def __init__(self, args):
        QApplication.__init__(self, args)
        self.tabs = QTabWidget()
        self.shooterTab = QWidget()
        self.fieldTab = QWidget()
        self.gunTypeTab = QWidget()
        self.gunTab = QWidget()
        self.shotTab = QWidget()

        self.setShooterTab()
        self.tabs.addTab(self.shooterTab, 'Shooters')


    def setShooterTab(self):
        shooterLayout = QVBoxLayout()

        # table part
        tableWidget = QWidget()
        tableLayout = QVBoxLayout()

        shooterTable = QTableWidget()
        tableLayout.addWidget(shooterTable)

        tableWidget.setLayout(tableLayout)

        # new shooter part
        newShooterWidget = QWidget()
        newShooterLayout = QFormLayout()

        SSN = QLineEdit()
        SSN.setInputMask('9999999999')
        nameSurname = QLineEdit()
        birthDate = QLineEdit()
        birthDate.setInputMask('99/99/9999')
        communication = QLineEdit()
        communication.setInputMask('+99_9999_999_9999')

        newShooterLayout.addRow('SSN : ', SSN)
        newShooterLayout.addRow('Name Surname : ', nameSurname)
        newShooterLayout.addRow('Birth Date : ', birthDate)
        newShooterLayout.addRow('Communication : ', communication)

        newShooterWidget.setLayout(newShooterLayout)

        shooterLayout.addWidget(tableWidget)
        shooterLayout.addWidget(newShooterWidget)

        self.shooterTab.setLayout(shooterLayout)

'''
	def setFieldTab (self):

	def setGunTypeTab (self):

	def setGunTab (self):

	def setShotTab (self):

	def setMainWindow(self):
'''