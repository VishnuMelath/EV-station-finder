import os
import pymysql


mydb = pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                            )
                    
# Creating a cursor object to interact with the database
mycursor = mydb.cursor()

# Executing a SQL query

# query = "insert into users values(\'dh121\',\'ajith anand\',\'qwerytwrkjgvwdacgvhgdsavchgvdchg vcghgvchkgsdvchghgdschgjhbdkhdksakjhvjhvjhgvjhgvytsadvcygtdsavcydsgtcvduygtsvuygvdsycvyvcfdgvskjhvfjdvjyhgjggv\')"
query1="select * from users"
# mycursor.execute(query1)
mydb.commit()
# Fetching the result
mycursor.execute(query1)
result = mycursor.fetchall()
mycursor.close
# Printing the result
for row in result:
  print(row)
  
  mycursor.close()
