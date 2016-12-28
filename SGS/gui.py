from PyQt4.QtGui import *
from PyQt4.QtCore import *

class GUI(QApplication):
    def __init__(self, args, org):
        QApplication.__init__(self, args)

        self.__o = org

        self.mainWindow = QMainWindow()
        self.mainWindow.setMaximumSize(500, 800)
        self.tabs = QTabWidget()
        self.tabs.setMinimumWidth(500)
        self.mainWindow.setCentralWidget(self.tabs)
        self.shooterTab = QWidget()
        self.fieldTab = QWidget()
        self.gunTypeTab = QWidget()
        self.gunTab = QWidget()
        self.shotTab = QWidget()
        self.uses_fieldTab = QWidget()

        self.centerWindow()
        self.createTabs()
        self.mainWindow.adjustSize()

    def createTabs(self):
        self.setShooterTab()
        self.tabs.addTab(self.shooterTab, 'Shooters')
        self.setFieldTab()
        self.tabs.addTab(self.fieldTab, 'Shooting Fields')
        self.setGunTypeTab()
        self.tabs.addTab(self.gunTypeTab, 'Gun Types')
        self.setGunTab()
        self.tabs.addTab(self.gunTab, 'Guns')
        self.setShotTab()
        self.tabs.addTab(self.shotTab, 'Shots')

    def setShooterTab(self):
        shooterLayout = QVBoxLayout()

        # table part
        tableWidget = self.__o.getTable('shooter_ob_name')

        # new shooter part
        newShooterWidget = QWidget()
        newShooterLayout = QFormLayout()

        SSN = QLineEdit()
        SSN.setInputMask('9999999999')
        SSN.setMaximumWidth(150)
        nameSurname = QLineEdit()
        nameSurname.setMaximumWidth(150)
        birthDate = QLineEdit()
        birthDate.setMaximumWidth(150)
        birthDate.setInputMask('9999-99-99')
        communication = QLineEdit()
        communication.setMaximumWidth(150)
        communication.setInputMask('+99-999-999-9999')

        newShooterLayout.addRow('SSN : ', SSN)
        newShooterLayout.addRow('Name Surname : ', nameSurname)
        newShooterLayout.addRow('Birth Date : ', birthDate)
        newShooterLayout.addRow('Communication : ', communication)

        # ComboBox for membership selection
        memberShipWidget = QWidget()
        membershipLayout = QHBoxLayout()
        membershipLayout.setAlignment(Qt.AlignLeft)
        membershipText = QLabel()
        membershipText.setText('Would you like to be a member?')
        membershipCombo = QComboBox()
        membershipCombo.addItem('Yes')
        membershipCombo.addItem('No')
        membershipLayout.addWidget(membershipText)
        membershipLayout.addWidget(membershipCombo)
        memberShipWidget.setLayout(membershipLayout)



        newShooterWidget.setLayout(newShooterLayout)


        filterLayout = QHBoxLayout()

        # Creates a combo box
        filterCombo = QComboBox()
        items = ['None', 'Success', 'Members', 'Not Members']
        filterCombo.addItems(items)
        filterCombo.setMaximumWidth(150)

        # Creates a button
        filterButton = QPushButton()
        filterButton.setText('Filter')
        filterButton.setMaximumWidth(150)
        #Shooter filtreleme



        #filterInput = QLineEdit()
        #filterInput.setFixedWidth(100)

        filterLayout.addWidget(filterCombo)
        filterLayout.addWidget(filterButton)
        filterLayout.setAlignment(Qt.AlignLeft)

        filterWidget = QWidget()
        filterWidget.setLayout(filterLayout)

        addButton = QPushButton()
        addButton.setText('Add Shooter')
        #Shooter ekleme



        addShooterText = QLabel()
        addShooterText.setText('Please enter the required information below to add a new shooter:')

        shooterLayout.addWidget(filterWidget)
        shooterLayout.addWidget(tableWidget)
        shooterLayout.addWidget(addShooterText)
        shooterLayout.addWidget(newShooterWidget)
        shooterLayout.addWidget(memberShipWidget)
        shooterLayout.addWidget(addButton)

        self.shooterTab.setLayout(shooterLayout)

        # Handling events
        newShooterInfo = [SSN.text()]
        QObject.connect(addButton, SIGNAL("clicked()"),
                        lambda: self.addShooter('shooter' ,
                                                SSN.text(),
                                                nameSurname.text(),
                                                birthDate.text(),
                                                communication.text(),
                                                membershipCombo.currentText(),
                                                tableWidget,
                                                shooterLayout))

        QObject.connect(filterButton, SIGNAL("clicked()"), lambda: buttonClicked())

    def setFieldTab(self):
        fieldLayout = QVBoxLayout()

        # Table
        tableWidget = self.__o.getTable("field_ob_name")

        # New Field
        newFieldWidget = QWidget()
        newFieldLayout = QFormLayout()

        location = QLineEdit()
        location.setMaximumWidth(150)
        name = QLineEdit()
        name.setMaximumWidth(150)
        maxRange = QLineEdit()
        maxRange.setMaximumWidth(150)

        newFieldLayout.addRow('Location: ', location)
        newFieldLayout.addRow('Name: ', name)
        newFieldLayout.addRow('Maximum Range: ', maxRange)

        newFieldWidget.setLayout(newFieldLayout)

        filterLayout = QHBoxLayout()

        # Creates a combo box
        filterCombo = QComboBox()
        items = ['None', 'Location', 'Name', 'Throng']
        filterCombo.addItems(items)
        filterCombo.setMaximumWidth(150)

        # Creates a button
        filterButton = QPushButton()
        filterButton.setText('Filter')
        filterButton.setMaximumWidth(150)
        #Field filtreleme
        QObject.connect(filterButton, SIGNAL("clicked()"), lambda: buttonClicked())


        #filterInput = QLineEdit()
        #filterInput.setFixedWidth(100)

        filterLayout.addWidget(filterCombo)
        #filterLayout.addWidget(filterInput)
        filterLayout.addWidget(filterButton)
        filterLayout.setAlignment(Qt.AlignLeft)

        filterWidget = QWidget()
        filterWidget.setLayout(filterLayout)

        addButton = QPushButton()
        addButton.setText('Add Field')
        #Field ekleme
        QObject.connect(addButton, SIGNAL("clicked()"), lambda: buttonClicked())


        addFieldText = QLabel()
        addFieldText.setText('Please enter the required information below to add a new field:')

        fieldLayout.addWidget(filterWidget)
        fieldLayout.addWidget(tableWidget)
        fieldLayout.addWidget(addFieldText)
        fieldLayout.addWidget(newFieldWidget)
        fieldLayout.addWidget(addButton)

        self.fieldTab.setLayout(fieldLayout)

    def setGunTypeTab(self):
        gunTypeLayout = QVBoxLayout()

        # table part
        tableWidget = self.__o.getTable('gun_type_ob_name')

        # new shooter part
        newGunTypeWidget = QWidget()
        newGunTypeLayout = QFormLayout()

        name = QLineEdit()
        name.setMaximumWidth(150)
        charge = QLineEdit()
        charge.setMaximumWidth(150)
        ammoPercentage = QLineEdit()
        ammoPercentage.setMaximumWidth(150)

        fieldIDLayout = QHBoxLayout()
        fieldIDText = QLabel()
        fieldIDText.setText('Field ID : ')
        fieldIdList = [QCheckBox() for i in range(5)]
        fieldIDLayout.addWidget(fieldIDText)
        k = 1
        for checkbox in fieldIdList:
            checkbox.setText(str(k))
            fieldIDLayout.addWidget(checkbox)
            k += 1

        fieldIDWidget = QWidget()
        fieldIDWidget.setLayout(fieldIDLayout)

        newGunTypeLayout.addRow('Name : ', name)
        newGunTypeLayout.addRow('Charge : ', charge)
        newGunTypeLayout.addRow('Ammo Percentage : ', ammoPercentage)

        newGunTypeWidget.setLayout(newGunTypeLayout)

        filterLayout = QHBoxLayout()

        # Creates a combo box
        filterCombo = QComboBox()
        items = ['None', 'Name', 'Charge', 'Ammo %']
        filterCombo.addItems(items)
        filterCombo.setMaximumWidth(150)

        # Creates a button
        filterButton = QPushButton()
        filterButton.setText('Filter')
        filterButton.setMaximumWidth(150)
        #Silah tipi filtreleme
        QObject.connect(filterButton, SIGNAL("clicked()"), lambda: buttonClicked())

        #filterInput = QLineEdit()
        #filterInput.setFixedWidth(100)

        filterLayout.addWidget(filterCombo)
        #filterLayout.addWidget(filterInput)
        filterLayout.addWidget(filterButton)
        filterLayout.setAlignment(Qt.AlignLeft)

        filterWidget = QWidget()
        filterWidget.setLayout(filterLayout)

        addButton = QPushButton()
        addButton.setText('Add Gun Type')
        #Gun Type Ekleme
        QObject.connect(addButton, SIGNAL("clicked()"), lambda: buttonClicked())


        addGunTypeText = QLabel()
        addGunTypeText.setText('Please enter the required information below to add a new gun type:')

        gunTypeLayout.addWidget(filterWidget)
        gunTypeLayout.addWidget(tableWidget)
        gunTypeLayout.addWidget(addGunTypeText)
        gunTypeLayout.addWidget(newGunTypeWidget)
        gunTypeLayout.addWidget(fieldIDWidget)
        gunTypeLayout.addWidget(addButton)

        self.gunTypeTab.setLayout(gunTypeLayout)

    def setGunTab(self):
        gunLayout = QVBoxLayout()

        # Table
        tableWidget = self.__o.getTable('gun_ob_name')

        # New Gun
        newGunWidget = QWidget()
        newGunLayout = QFormLayout()

        serialNumber = QLineEdit()
        serialNumber.setMaximumWidth(150)
        name = QLineEdit()
        name.setMaximumWidth(150)
        gunTypeID = QLineEdit()
        gunTypeID.setMaximumWidth(150)

        newGunLayout.addRow('Serial Number: ', serialNumber)
        newGunLayout.addRow('Name: ', name)
        newGunLayout.addRow('Gun Type (ID): ', gunTypeID)

        newGunWidget.setLayout(newGunLayout)

        filterLayout = QHBoxLayout()

        # Creates a combo box
        filterCombo = QComboBox()
        items = ['None', 'Location', 'Name', 'Throng']
        filterCombo.addItems(items)
        filterCombo.setMaximumWidth(150)

        # Creates a button
        filterButton = QPushButton()
        filterButton.setText('Filter')
        filterButton.setMaximumWidth(150)
        #Silah Filtreleme
        QObject.connect(filterButton, SIGNAL("clicked()"), lambda: buttonClicked())


        #filterInput = QLineEdit()
        #filterInput.setFixedWidth(100)

        filterLayout.addWidget(filterCombo)
        #filterLayout.addWidget(filterInput)
        filterLayout.addWidget(filterButton)
        filterLayout.setAlignment(Qt.AlignLeft)

        filterWidget = QWidget()
        filterWidget.setLayout(filterLayout)

        addButton = QPushButton()
        addButton.setText('Add Gun')
        #Gun ekleme
        QObject.connect(addButton, SIGNAL("clicked()"), lambda: buttonClicked())


        addGunText = QLabel()
        addGunText.setText('Please enter the required information below to add a new gun:')

        gunLayout.addWidget(filterWidget)
        gunLayout.addWidget(tableWidget)
        gunLayout.addWidget(addGunText)
        gunLayout.addWidget(newGunWidget)
        gunLayout.addWidget(addButton)

        self.gunTab.setLayout(gunLayout)

    def setShotTab(self):
        shotLayout = QVBoxLayout()

        # Table
        tableWidget = self.__o.getTable('shot_ob_start_date')

        # New Field
        newShotWidget = QWidget()
        newShotLayout = QFormLayout()

        # Shooter SSN input UI
        ShooterSSNWidget = QWidget()
        shooterSSNLayout = QHBoxLayout()
        shooterIDText = QLabel()
        shooterIDText.setText('Shooter : ')
        shooterIDInputField = QComboBox()
        shooterIDInputField.addItems(['1','2','3'])
        shooterSSNLayout.addWidget(shooterIDText)
        shooterSSNLayout.addWidget(shooterIDInputField)
        shooterSSNLayout.setAlignment(Qt.AlignLeft)
        ShooterSSNWidget.setLayout(shooterSSNLayout)

        # Gun ID Input UI
        gunIDWidget = QWidget()
        gunIDLayout = QHBoxLayout()
        gunIDText = QLabel()
        gunIDText.setText('Gun ID: ')
        gunIDCombo = QComboBox()
        gunIDList = ['1', '2', '3']
        gunIDCombo.addItems(gunIDList)
        gunIDLayout.addWidget(gunIDText)
        gunIDLayout.addWidget(gunIDCombo)
        gunIDLayout.setAlignment(Qt.AlignLeft)
        gunIDWidget.setLayout(gunIDLayout)

        # Field ID input UI
        fieldIDWidget = QWidget()
        fieldIDLayout = QHBoxLayout()
        fieldIDText = QLabel()
        fieldIDText.setText('Fieild ID')
        fieldIDCombo = QComboBox()
        fieldIDList = ['4', '12', '5']
        fieldIDCombo.addItems(fieldIDList)
        fieldIDLayout.addWidget(fieldIDText)
        fieldIDLayout.addWidget(fieldIDCombo)
        fieldIDLayout.setAlignment(Qt.AlignLeft)
        fieldIDWidget.setLayout(fieldIDLayout)



        shooterSSN = QLineEdit()
        shooterSSN.setMaximumWidth(150)
        gunID = QLineEdit()
        gunID.setMaximumWidth(150)
        fieldID = QLineEdit()
        fieldID.setMaximumWidth(150)
        successPercentage = QLineEdit()
        successPercentage.setInputMask('99.9')
        successPercentage.setMaximumWidth(150)
        startDate = QLineEdit()
        startDate.setInputMask('9999-99-99 99:99')
        startDate.setMaximumWidth(150)
        stopDate = QLineEdit()
        stopDate.setInputMask('9999-99-99 99:99')
        stopDate.setMaximumWidth(150)

        #newShotLayout.addRow('Shooter SSN: ', shooterSSN)
        #newShotLayout.addRow('Gun ID: ', gunID)
        #newShotLayout.addRow('Field ID: ', fieldID)
        newShotLayout.addRow('Success Percentage: ', successPercentage)
        newShotLayout.addRow('Start Date: ', startDate)
        newShotLayout.addRow('Stop Date: ', stopDate)

        newShotWidget.setLayout(newShotLayout)

        filterLayout = QHBoxLayout()

        # Creates a combo box
        filterCombo = QComboBox()
        items = ['None', 'Location', 'Name', 'Throng']
        filterCombo.addItems(items)
        filterCombo.setMaximumWidth(150)

        # Creates a button
        filterButton = QPushButton()
        filterButton.setText('Filter')
        filterButton.setMaximumWidth(150)
        #Shot Filtreleme
        QObject.connect(filterButton, SIGNAL("clicked()"), lambda: buttonClicked())


        filterInput = QLineEdit()
        filterInput.setFixedWidth(100)

        filterLayout.addWidget(filterCombo)
        filterLayout.addWidget(filterInput)
        filterLayout.addWidget(filterButton)
        filterLayout.setAlignment(Qt.AlignLeft)

        filterWidget = QWidget()
        filterWidget.setLayout(filterLayout)

        addButton = QPushButton()
        addButton.setText('Add Shot')
        #Shot ekleme
        QObject.connect(addButton, SIGNAL("clicked()"), lambda: buttonClicked())


        addShotText = QLabel()
        addShotText.setText('Please enter the required information below to add a new shot:')


        shotLayout.addWidget(filterWidget)
        shotLayout.addWidget(tableWidget)
        shotLayout.addWidget(addShotText)
        shotLayout.addWidget(ShooterSSNWidget)
        shotLayout.addWidget(gunIDWidget)
        shotLayout.addWidget(fieldIDWidget)
        shotLayout.addWidget(newShotWidget)
        shotLayout.addWidget(addButton)

        self.shotTab.setLayout(shotLayout)

    def setUses_fieldTab(self):
        uses_fieldLayout = QVBoxLayout()


    def centerWindow(self):
        resolution = QDesktopWidget().screenGeometry()
        self.mainWindow.move((resolution.width() / 2) - (self.mainWindow.frameSize().width() / 2),
                             (resolution.height() / 2) - (self.mainWindow.frameSize().height() / 2))

    def addShooter(self, tableName,SSN,nameSurname,birthDate,communication,membershipCombo, tableWidget, tableLayout):
        newShooterData = []

        newShooterData.append(int(SSN))
        newShooterData.append(str(nameSurname))
        newShooterData.append(str(birthDate))
        newShooterData.append(str(communication))

        if membershipCombo == 'Yes':
            newShooterData.append(True)
        else:
            newShooterData.append(False)

        try:
            self.__o.addItem(tableName, newShooterData)
            tableLayout.itemAt(1).widget().setParent(None)
            tableWidget = self.__o.getTable('shooter')
            tableLayout.addWidget(tableWidget)
            tableLayout.update()
        except Exception as e:
            self.showPopupMessage(e.message)

    def showPopupMessage(self,message):
        popup = QWidget()
        popup.setGeometry(600,400,40,30)
        popupMessage = QLabel()
        popupMessage.setText(message)
        okButton = QPushButton('OK')
        popupLayout = QVBoxLayout()
        popupLayout.addWidget(popupMessage)
        popupLayout.addWidget(okButton)
        popup.setLayout(popupLayout)

        QObject.connect(okButton, SIGNAL("clicked()"), lambda: popup.close())

        popup.show()



def buttonClicked():
    print('Vuuhuuu!!')