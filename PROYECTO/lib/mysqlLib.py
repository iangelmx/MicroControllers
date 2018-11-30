import pymysql

class Bd():

	#Base de datos
	hostname = 'localhost'
	username = 'root'
	password = ''
	database = None

	def __init__(self,database, hostname='localhost', username='root', password='', port=3306):
		self.hostname=hostname
		self.username=username
		self.password=password
		self.database=database
		self.port=port

	def getAutoIncrement(self, table):
		return self.doQuery('''SELECT `AUTO_INCREMENT`
								FROM  INFORMATION_SCHEMA.TABLES
								WHERE TABLE_SCHEMA = '{}'
								AND   TABLE_NAME   = '{}';'''.format(self.database,table))[0][0]
		
	def insertInDB(self, table, params):#Inserta un nuevo elemento en la BD, los parametros van en forma de lista al igua que los valores regra
		myConnection =pymysql.connect( host=self.hostname, user=self.username, passwd=self.password, db=self.database, port=self.port )	#Crear la conexión con la BD
		cur = myConnection.cursor()
		myQuery="INSERT INTO "+table+" ( "
		
		for key in params:#Agregar la lista de parámetros separada por comas
			myQuery+=key +","
		myQuery = myQuery[:-1] + ") VALUES (" #Quitar la última coma y preparar para los parámetros

		for key in params: #Agregar el listado de valores
			if params[key]:
				myQuery+=""+self.escapeString(params[key])+","
			else: myQuery+=' NULL ,'
		myQuery = myQuery[:-1] + ");" #Quitar la última coma y preparar para los parámetros
		
		cur.execute( myQuery )
		myConnection.commit()
		result=cur.fetchall()
		myConnection.close()
		return True #MEJORA ISSSUE 13
	def updateInDB(self, table,upParams, whereParams=None):
		reserved=['=NULL','NOW()']

		myConnection =pymysql.connect( host=self.hostname, user=self.username, passwd=self.password, db=self.database )	#Crear la conexión con la BD
		cur = myConnection.cursor()
		myQuery="UPDATE "+table+" SET "
		for key in upParams:#Agregar la lista de cambios separados por comas
			
			if str(upParams[key]) in reserved:
				myQuery+=key+upParams[key]
			else:
				if upParams[key]:
					myQuery+=key+"="+self.escapeString(upParams[key])+","
				else:
					myQuery+=' '
		myQuery = myQuery[:-1] #Quitar la última coma

		if whereParams:
			myQuery += " WHERE "
			for key in whereParams:#Agregar la lista de parámetros separada por comas
				
				myQuery+=key+"="+self.escapeString(whereParams[key])+" AND "
			myQuery = myQuery[:-5] + ";" #Quitar la última coma y preparar para los parámetros



		cur.execute( myQuery )
		myConnection.commit()
		
		result=cur.fetchall()

		myConnection.close()

		return True #MEJORA ISSSUE 14	
	def doQuery(self,  myQuery) :
		myConnection =pymysql.connect( host=self.hostname, user=self.username, passwd=self.password, db=self.database, charset='utf8', port=self.port )	#Crear la conexión con la BD
		cur = myConnection.cursor()
		cur.execute( myQuery )	
		result=cur.fetchall()
		myConnection.commit()
		myConnection.close()
		return result
	def existsInDB(self, table,params):#Checa si existe un elemento con un valor value en un parametro param dentro de la tabla table. Si existr rgresa True, sino False
	    query="SELECT COUNT(1) FROM "+table +" WHERE "
	    for key in params:#Agregar la lista de cambios separados por comas
	        query+=key+"="+self.escapeString(params[key])+" AND "
	    query=query[:-4]
	    #+param+" = '"+value+"'"#Un query para contar las veces que se repite un param de valor value en table
	    amount=self.doQuery(query)
	    if str(amount[0][0])=="0":#Si no existe
	        return False
	    return True #Si existe
	def escapeString(self, original):#Escapa el string
		myConnection =pymysql.connect( host=self.hostname, user=self.username, passwd=self.password, db=self.database )	#Crear la conexión con la BD
		cur = myConnection.cursor()	
		result=myConnection.escape(str(original))
		myConnection.commit()
		myConnection.close()
		return result
	def insertOrUpdate(self, table, upParams, whereParams): #Regresa [exito, esNuevo]
		try:
			#Si ya existe:
			if self.existsInDB(table,whereParams):
				self.updateInDB(table,upParams, whereParams)
				return [True,False]
			else:#Si hay que agregarlo a la DB
				self.insertInDB(table, upParams)
				return [True, True]
		except Exception as e:
			print(str(e))
			return [False,None]

	def selectAllAsObject(self, table, whereParams=None, sort=None):
		#Obtener los nombres de las columnas
		columns=self.doQuery("SHOW COLUMNS FROM "+table)
		columnNames=[]
		for column in columns:
			columnNames.append(column[0])
		#Agregar todas las collumnas en orden a la Query
		query='SELECT '
		for column in columnNames:
			query+=column+','
		query=query[:-1]
		query+=' FROM '+table
		#Condiciones
		if whereParams:
			query+=' WHERE '
			for key in whereParams:#Agregar la lista de parámetros separada por comas
				query+=key +"="+self.escapeString(whereParams[key])+","
			
			query = query[:-1]  #Quitar la última coma y preparar para los parámetros
		s=' '
		if sort:
			s=' ORDER BY '
			for so in sort:
				s=s+str(so[0])+' '+str(so[1])+','
			s=s[:-1]
		query+=s
		#Hacer la query
		results=self.doQuery(query)
		#Pasar a objeto
		objects=[]
		for result in results:
			ob={}
			for key, value in zip(columnNames, result):
				ob[key]=value
			objects.append(ob)

		return objects
	def getFields(self, table, fields,whereParams=None, sort=None, limit=None):
		reservedWhere=['=NOW()', '>NOW()', '<NOW()', 'IS NULL' , 'IS NOT NULL']
		#obtener el listado de los valores deseados
		d=''
		for f in fields:
			d=d+str(f)+','
		d=d[:-1]
		w=''
		if whereParams:
			w='WHERE '
			for key in whereParams:#Agregar la lista de parámetros separada por comas
				if whereParams[key] in reservedWhere:
					w+=key+' '+whereParams[key]+" AND "
				else:
					if whereParams[key][:2]=='!=':
						w+=key+"!="+self.escapeString(whereParams[key])+" AND "
					else:
						w+=key+"="+self.escapeString(whereParams[key])+" AND "
			w = w[:-5]

		s=''
		if sort:
			s='ORDER BY '
			for so in sort:
				s=s+str(so[0])+' '+str(so[1])+','
			s=s[:-1]
		l=''
		if limit:
				l='LIMIT '+str(int(limit))

		query="SELECT "+d+' FROM '+table+' '+w+' '+s+' '+l+' ;'
		res=self.doQuery(query)

		valores=[]
		for line in res:
			objeto={}
			for v, key in zip(line, fields):
				objeto[key]=v
			valores.append(objeto)
		return valores