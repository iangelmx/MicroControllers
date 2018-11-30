import time
import serial
from lib.mysqlLib import Bd
import getpass

maxVol = 4
div = ( maxVol * 255 ) / 5

def leeSerial():
	ser = serial.Serial( port='COM5',
								baudrate=9600,
								parity=serial.PARITY_NONE,
								timeout=0)  # open serial port
	line=[]
	a=0
	while True:
		a+=1
		#print(a)
		#print("Aquí")
		d = 0
		try:
			#ser = serial.Serial('COM5')  # open serial port
			for c in ser.read():
				a+=1
				line.append(c)
				print("Char->", c)
				if a%1000==0:
					#print(bd.doQuery("SELECT USER() FROM DUAL;")[0])
					voltaje = ((int(c)*maxVol)/div)
					print(bd.doQuery("INSERT INTO volhumrel(adc, vol, hr) VALUES ({},{},{});".format(
						c,
						voltaje,
						(voltaje*100/maxVol)
					 )) )
					#print("Inserto a bd")
					#print("A1->"+str(a))
					a=0
					print("Working hard...")
					print("Working hard...")
					print("Working hard...")
					print("Working hard...")
					print("Working hard...")
					print("Working hard...")
					#input("A2->"+str(a))
				if c == '\n':
					print("Line: " + ''.join(line))
					line = []
					break
			if a % 100 == 0:
				pass
				##bd.insertInDB("volhumrel", {'adc': d, 'vol':((int(d)*5)/255), 'hr':((int(d)*100)/255)})
		except Exception as ex:
			print(ex)
			input("Exception")
		#time.sleep(1)


if __name__ == '__main__':
	pswd = getpass.getpass('Password:')
	bd=Bd(username = 'adminNoDrop',
		hostname = '201.107.5.3',
		#hostname = '127.0.0.1',
		password = '',
		database = 'pdstelmex_preprod',
		port=4002
		)

	print(bd.doQuery("SELECT USER() FROM DUAL;")[0])

	leeSerial()
	ser.close()             # close port
