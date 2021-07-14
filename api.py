from flask import Flask, json,jsonify,request
import pymysql
import random
import string
import pyotp
connection = pymysql.connect(
        host='127.0.0.1',
        user='root', 
        password = "",
        db='company',
        )
cur =connection.cursor()


app = Flask(__name__)#instantiate my app
# mysql  = MySQL(app)

@app.route('/hello')
def index():
    return jsonify(error="hello")

@app.route('/agentLogin')
def agentLogin():
    try:
        if 'username' in request.args and 'password' in request.args:
            username = request.args['username']
            password = request.args['password']
            cur.execute('select id from employer where username="'+username+'"and password = "'+password+'";')
            result = []
            result = cur.fetchall()
            if  len(result)>0:
                id = result[0][0]
                print ("id is ="+str(id))
                cur.execute('select id from agent where emp_id='+str(id))
                result = []
                result = cur.fetchall()
                if  len(result)>0:
                    rand = getRandom(10)
                    cur.execute('UPDATE employer SET token ="'+rand+'" WHERE employer.id ='+str(id))
                    cur.execute('INSERT INTO login (emp_id,imei) VALUES ('+str(id)+',"348239047235");')
                    #pymysql.connection.commit()
                    connection.commit()
                    return jsonify(token=rand)
                else:
                    return jsonify(error="employer try to access to agent account")
            else:
                return jsonify(error='employer not founded')
        return jsonify(error='request args not founded') 
    
    except Exception as e:
        return jsonify(error=str(e))



@app.route('/employerLogin')# http://192.168.1.3:5000/employerLogin?username=walid2323&password=2323
def employerLogin():
    try:
        if 'username' in request.args and 'password' in request.args:
            username = request.args['username']
            password = request.args['password']
            cur.execute('select id from employer where username="'+username+'"and password = "'+password+'";')
            result = []
            result = cur.fetchall()
            if  len(result)>0:
                id = result[0][0]
                tok = getRandom(20)
                cur.execute('UPDATE employer SET token ="'+tok+'" WHERE employer.id ='+str(id))    #saving a token
                #pymysql.connection.commit()
                connection.commit()
                #ensure uncity of secret
                is_exist_key=True
                while(is_exist_key):
                    sec =pyotp.random_base32()
                    cur.execute('select id from secret where value = "'+sec+'";')
                    result = []
                    result = cur.fetchall()
                    if  len(result)==0:
                        is_exist_key=False

                cur.execute('INSERT INTO secret (owner,value) VALUES ('+str(id)+',"'+sec+'");') #saving a secret
                cur.execute('INSERT INTO login (emp_id,imei) VALUES ('+str(id)+',"348239047235");') #saving his login
                connection.commit()#update DB
                return jsonify(id=id, token=tok, secret=sec)
            else:
                return jsonify(error='employer not founded')
        return jsonify(error='request args not founded') 
    
    except Exception as e:
        return jsonify(error=str(e))



@app.route('/qrScan') #http://192.168.1.3:5000/qrScan?id=1&otp=817492&emp_imei=1012&token=LN2W6S06MZ&agent_imei=2020
def qrScan():
    try:  # qrScan?id=1&otp=817492&emp_imei=1012&token=74RFNXYDU782XV6LLNFR&agent_imei=202
        if 'id' in request.args and  'otp' in request.args and 'emp_imei' in request.args and 'token' in request.args and 'agent_imei' in request.args:
            emp_imei  = request.args['emp_imei']
            id        = request.args['id']
            otp       = request.args['otp']
            agent_imei= request.args['agent_imei']
            token     = request.args['token']
            #getting the secret
            cur.execute('select value from secret where secret.owner ='+id+' order by date desc limit 1')
            result = []
            result = cur.fetchall()
            if  len(result)>0:
                secret = result[0][0]  
                 #checking otp
                totp = pyotp.TOTP(secret)
                res = totp.verify(otp)
                print('here')
                cur.execute('select id from agent where emp_id = (select id from employer where token = "'+token+'" )')
                result = []
                result = cur.fetchall()
                if  len(result)>0:
                    agent_id = result[0][0]
                    query = 'INSERT INTO scan (agent_id, emp_id, imei_agent, imei_emp, result) VALUES ('+str(agent_id)+', '+str(id)+', "'+agent_imei+'", "'+emp_imei+'", '+str(res)+');';
                    cur.execute(query);
                    connection.commit()
                    return jsonify(result=res)
                else:
                    return jsonify(error='agent not founded')
            else:
                return jsonify(error='employer not founded')
        else:
            return jsonify(error="Unknown")
    except Exception as e:
        return jsonify(error=str(e))              




def getRandom(size=6):
    return ''.join(random.choice( string.ascii_uppercase + string.digits ) for _ in range(size))



@app.errorhandler(404)
def page_not_found(e):
    return "<h1>404</h1><p>The resource could not be found.</p>", 404


if __name__ =="__main__":   # which the difference between this and run(app) without checking
    app.run(host='0.0.0.0', debug=True)

#app.run()#running my app    #host='0.0.0.0', port=
 
