import pymongo
from tabulate import tabulate
from pprint import pprint
import time


def showDatabase():
    print("-> SHOW DATABASES")

    print(tabulate({
            'Database': myclient.list_database_names()
        },
        headers='keys',
        tablefmt='fancy_grid')
    )

    return myclient["dbms-prac"]


def createAndInsertInCollection():
    print("\n\n-> CREATE COLLECTION: empDetails")

    if 'empDetails' in mydb.list_collection_names():
        mydb['empDetails'].drop()
    
    myCollection = mydb['empDetails']

    myData = [
        {
            "First_Name": "Fathima",
            "Last_Name": "Sheik",
            "Date_Of_Birth": "1990-02-16",
            "e_mail": "Fathima_Sheik.123@gmail.com",
            "phone": "9000054321"
        },
        {
            "First_Name": "Gaurav",
            "Last_Name": "Dalvi",
            "Date_Of_Birth": "2000-10-24",
            "e_mail": "dalvi2000@gmail.com",
            "phone": "9474121846"
        },
        {
            "First_Name": "Rachel",
            "Last_Name": "Christopher",
            "Date_Of_Birth": "1990-02-16",
            "e_mail": "Rachel_Christopher.123@gmail.com",
            "phone": "9000054321"
        },
        {
            "First_Name": "Alex",
            "Last_Name": "Ron",
            "Date_Of_Birth": "1996-04-26",
            "e_mail": "alex123@gmail.com",
            "phone": "9784514545"
        },
        {
            "First_Name": "James",
            "Last_Name": "Ford",
            "Date_Of_Birth": "1998-01-14",
            "e_mail": "fordjames123@gmail.com",
            "phone": "9413575512"
        },
        {
            "First_Name": "Radhika",
            "Last_Name": "Sharma",
            "Date_Of_Birth": "1995-09-26",
            "e_mail": "radhika_sharma.123@gmail.com",
            "phone": "9848022338"
        }
    ]

    myCollection.insert_many(myData)
    print(tabulate({
            'Collections': mydb.list_collection_names()
        },
        headers='keys',
        tablefmt='fancy_grid')
    )

    print("\n\n-> INSERT INTO: empDetails")

    cursor = myCollection.find({})
    for document in cursor: 
        pprint(document)

    return myCollection


def updateInCollection():
    print("\n\n-> UPDATE Collection: SET new Date_Of_Birth to 1995-01-01 if $it > 1995-01-01")

    myquery = {
        "Date_Of_Birth": {
            "$gt": "1995-01-01"
        }
    }

    newvalues = {
        "$set": {
            "Date_Of_Birth": "1995-01-01"
        }
    }

    myCollection.update_many(myquery, newvalues)

    cursor = myCollection.find({})
    for document in cursor: 
        pprint(document)


def deleteInCollection():
    print("\n\n-> DELETE FROM Collection: empDetails Date_Of_Birth >= 1995-01-01")

    myquery = {
        "Date_Of_Birth": {
            "$gte": "1995-01-01"
        }
    }

    myCollection.delete_many(myquery)

    cursor = myCollection.find({})
    for document in cursor: 
        pprint(document)


if __name__ == "__main__":
    try:
        myclient = pymongo.MongoClient("mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000")
        myclient.server_info()
        print("-> MongoDB is connected to Python.\n\n")
    except pymongo.errors.ServerSelectionTimeoutError as err:
        print("-> Connection error!!!")
        exit()

    mydb = showDatabase()
    myCollection = createAndInsertInCollection()
    updateInCollection()
    deleteInCollection()
    print("\n\n-> Disconnecting MongoDB connection")
    myclient.close()



