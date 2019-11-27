# Version 2

import csv
import sqlite3
from sqlite3 import Error


connection = None
connection = sqlite3.connect(r"OnlineMusicStore_Python.db")
connection.text_factory = str
cursor = connection.cursor()

csv_file = open("hw5_original.csv", "r")
csv_reader = csv.reader(csv_file, delimiter=',')
csv_data = []
for row in csv_reader:
    csv_data.append(tuple(row))

cursor.execute("CREATE TABLE hw5_original " + str(csv_data[0]) + " ;")

with open('hw5_original.csv','r') as fin:
    # csv.DictReader uses first line in file for column headings by default
    dr = csv.DictReader(fin) # comma is default delimiter
    to_db = [(i['TrackName'], i['Composer'], i['TrackLength'], i['TrackSizeBytes'], i['TrackPrice'], i['Genre'], i['MediaType'], i['AlbumTitle'], i['ArtistName'], i['InvoiceItemQuantity'], i['InvoiceItemUnitPrice'], i['InvoiceId'], i['InvoiceDate'], i['InvoiceBillingAddress'], i['InvoiceBillingCity'], i['InvoiceBillingState'], i['InvoiceBillingCountry'], i['InvoiceBillingPostalCode'], i['CustomerFirstName'], i['CustomerLastName'], i['CustomerAddress'], i['CustomerCity'], i['CustomerState'], i['CustomerCountry'], i['CustomerPostalCode'], i['CustomerPhone'], i['CustomerFax'], i['CustomerEmail']) for i in dr]

cursor.executemany("INSERT INTO hw5_original VALUES (?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?);", to_db)
connection.commit()
connection.close()

# Credit to this StackOverflow post, whose solution works without having to remove that one problematic row
# https://stackoverflow.com/questions/2887878/importing-a-csv-file-into-a-sqlite3-database-table-using-python