# Version 1
import csv
import sqlite3
from sqlite3 import Error


connection = None
connection = sqlite3.connect(r"OnlineMusicStore_Python.db")
cursor = connection.cursor()

csv_file = open("hw5_original.csv", "r")
csv_reader = csv.reader(csv_file, delimiter=',')
csv_data = []
for row in csv_reader:
    csv_data.append(tuple(row))

csv_data[3667] = tuple([csv_data[3667][0].replace("'",'"')]) + csv_data[3667][1:]
# Row 3667 was causing a serious problem
# It's first element is: 'Nabucco: Chorus, "Va, Pensiero, Sull'ali Dorate"'
# The single quotation mark in "Sull'ali" was breaking the code
# Therefore, the above line replaces the single quote with a double quote

cursor.execute("CREATE TABLE hw5_original " + str(csv_data[0]) + " ;")

for row in csv_data[1:]:
    cursor.execute("INSERT INTO hw5_original" + str(csv_data[0]) + " VALUES " + str(row) + " ;")

csv_file.close()
cursor.close()
connection.commit()
connection.close()