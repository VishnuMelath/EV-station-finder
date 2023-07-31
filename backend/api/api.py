from flask import Flask,request,jsonify
import pymysql
import os




app=Flask(__name__)

@app.route('/',methods=['GET'])
def test():
    d={}
    # inputchr=str(request.args['query'])
    # aa=str(request.args['asd'])
    # answer=str(ord(inputchr))
    # d['output']=inputchr+aa
    return 'test'

@app.route('/login',methods=['POST'])
def login():
    d={}
    id1= request.form['email']
    password = request.form['password']
    db= pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                             autocommit=True
                           )
    mycursor = db.cursor()
    query = 'SELECT * FROM users WHERE email_id =\''+id1+'\' AND password =\''+password+'\''
    query1='SELECT * FROM admin WHERE id =\''+id1+'\' AND password =\''+password+'\''
    if mycursor.execute(query):
        result = mycursor.fetchall()
        mycursor.close()
        db.close()
        return jsonify(result)
    elif mycursor.execute(query1):
        mycursor.close()
        db.close()
        return 'admin'
    else:
        mycursor.close()
        db.close()
        return 'false'
    
@app.route('/userdata',methods=['POST'])
def userdata():
    id1= request.form['email']
    db= pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                             autocommit=True
                           )
    mycursor = db.cursor()
    query = 'SELECT * FROM users WHERE email_id =\''+id1+'\''
    if mycursor.execute(query):
        result = mycursor.fetchall()
        mycursor.close()
        db.close()
        return jsonify(result)
    else:
        mycursor.close()
        db.close()
        return 'false'
    
@app.route('/register',methods=['POST'])
def register():
    d={}
    id1 = request.form['email']
    password = request.form['password']
    name=request.form['name']
    db= pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                             autocommit=True
                           )
    mycursor = db.cursor()
    query = "insert into users values(\'"+id1+"\',\'"+name+"\',\'"+password+"\')"
    print(query)
    print(len(password))
    if mycursor.execute(query):
        mycursor.close()
        db.close()
        return 'true'
    else:
        mycursor.close()
        db.close()
        return 'false'

@app.route('/addfeedback',methods=['POST'])
def addfeedback():
    d={}
    name = request.form['name']
    feedback=request.form['feedback']
    db= pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                             autocommit=True
                           )
    mycursor = db.cursor()
    query = "insert into feedback(name,feedback) values(\'"+name+"\',\'"+feedback+"\')"
    print(query)
    if mycursor.execute(query):
        mycursor.close()
        db.close()
        return 'true'
    else:
        mycursor.close()
        db.close()
        return 'false'
    
@app.route('/showfeedback',methods=['GET'])
def showFeedback():
    db= pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                             autocommit=True
                           )
    mycursor=db.cursor()
    query="select * from feedback"
    if mycursor.execute(query):
        result = mycursor.fetchall()
        mycursor.close()
        db.close()
        return jsonify(result)
    else:
        mycursor.close()
        db.close()
        return 'false' 

@app.route('/deletefeedback',methods=['POST'])
def deleteFeedback():
    id1 = request.form['email']
    db= pymysql.connect(host='localhost',
                             user='root',
                             password=os.getenv("MysqlCred"),
                             database='users',
                             autocommit=True
                           )
    mycursor=db.cursor()
    query="delete from feedback where id1=\'"+id1+"\'"
    if mycursor.execute(query):
        mycursor.close()
        db.close()
        return 'true'
    else:
        mycursor.close()
        db.close()
        return 'false'       

if __name__=="__main__":
    app.run(host='0.0.0.0', port=8080,debug=True)
    
    