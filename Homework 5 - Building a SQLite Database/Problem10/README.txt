This zip file contains instructions related to Problem #10:

- Problem10.py (to run this code, execute this command in Terminal / Command Line:  python Problem10.py )
(NOTE1: You MUST have the hw5_original.csv file in the same directory where this script executes)
(NOTE2: There is a line of code, which changes a single quote ' to a double quote " in row 3667. This was necessary, because the code wouldn't run.)
The result should be a SQLite DB called "OnlineMusicStore_Python.db", which contains the hw5_original table.


- Problem10_Version2.py contains code, which will do the same thing as the above file. The same NOTE1 applies to it as well. This version of the code does NOT modify the data in the .csv file.
NOTE3: Problem10_Version2.py was adapted from a StackOverflow post: https://stackoverflow.com/questions/2887878/importing-a-csv-file-into-a-sqlite3-database-table-using-python

- Problem10.ipynb contains both versions of the code. It was where I originally wrote the code. It requires Jupyter Notebook/Lab to run. 

It is difficult to give additional reference to online materials I consulted, because I had already played around with connecting to a SQLite databases a month ago, based on inspiration from the Python/Java course.

Final NOTE: the python code assumes you have sqlite3 and csv libraries installed. Depending on your Python installation, getting these will differ.
If you have Anaconda, you can use the GUI to install them.
If you prefer Terminal/Command Line, try: 
pip install sqlite3
pip install csv
(If for whatever reason you don't have pip: https://pip.pypa.io/en/stable/installing/)

Hope this works!

Sincerely,
Kristiyan & Laurie