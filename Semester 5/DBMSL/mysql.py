import mysql.connector
from tabulate import tabulate


def showDatabase():
    print("-> SHOW DATABASES")

    mycursor.execute("SHOW DATABASES")
    print(tabulate(mycursor,
        headers=['Database'],
        tablefmt='fancy_grid')
    )

    mycursor.execute("USE dbmsl")


def createTable():
    print("\n\n-> CREATE TABLE")

    mycursor.execute("DROP TABLE library")
    mycursor.execute("CREATE TABLE library (ISBN VARCHAR(50) PRIMARY KEY, name VARCHAR(255), author VARCHAR(255), publisher VARCHAR(255), yearOfPublication INTEGER, cost FLOAT NOT NULL )")

    mycursor.execute("DESC library")
    print(tabulate(mycursor,
        headers=['Field', 'Type', 'Null', 'Key', 'Default', 'Extra'],
        tablefmt='fancy_grid')
    )


def insertInTable():
    print("\n\n-> INSERT INTO: library")

    sql = "INSERT INTO library VALUES (%s, %s, %s, %s, %s, %s)"
    val = [
        ('9874133548', 'Only Time Will Tell', 'Jeffery Archer', 'PAN', 2011, 562.45),
        ('9784157165', 'Midnights Children', 'Salman Rushdie', 'VINTAGE', 2013, 452.25),
        ('9457154812', 'Revolution 2020', 'Jeffery Archer', 'RUPA', 2011, 842.75),
        ('9421548465', 'The Old Man And His God', 'Sudha Murty', 'PENGUIN', 2006, 170.45)
    ]

    mycursor.executemany(sql, val)
    mydb.commit()

    mycursor.execute("SELECT * FROM library")

    print(tabulate(mycursor,
        headers=['ISBN', 'name', 'author', 'publisher', 'yearOfPublication', 'cost'],
        tablefmt='fancy_grid')
    )


def updateInTable():
    print("\n\n-> UPDATE TABLE: SET author for Revolution 2020")

    sql = "UPDATE library SET author=%s where name=%s"
    val = ('Chetan Bhagat', 'Revolution 2020')

    mycursor.execute(sql, val)
    mydb.commit()

    mycursor.execute("SELECT * FROM library")

    print(tabulate(mycursor,
        headers=['ISBN', 'name', 'author', 'publisher', 'yearOfPublication', 'cost'],
        tablefmt='fancy_grid')
    )


def deleteInTable():
    print("\n\n-> DELETE FROM TABLE: library WHERE ISBN is 9784157165")

    sql = "DELETE FROM library WHERE ISBN=%s"
    val = ('9784157165',)

    mycursor.execute(sql, val)
    mydb.commit()

    mycursor.execute("SELECT * FROM library")

    print(tabulate(mycursor,
        headers=['ISBN', 'name', 'author', 'publisher', 'yearOfPublication', 'cost'],
        tablefmt='fancy_grid')
    )


if __name__ == "__main__":
    mydb = mysql.connector.connect(
        host="localhost",
        user="proxzima",
        password="password"
    )

    if mydb.is_connected():
        print("-> MySQL connection is connected to Python.\n\n")

    mycursor = mydb.cursor()
    showDatabase()
    createTable()
    insertInTable()
    updateInTable()
    deleteInTable()
    print("\n\n-> Disconnecting MySQL connection")
    mycursor.close()
    mydb.close()



