import time
import serial
from lib.mysqlLib import Bd
import getpass

def leeSerial():
	while True:
		try:
			ser = serial.Serial('COM5')  # open serial port
			print(ser.name)         # check which port was really used
			ser.write(b'')     # write a string
			ser.close()             # close port
		except Exception as ex:
			print(ex)
			pass
		time.sleep(0.5)


if __name__ == '__main__':
	pswd = getpass.getpass('Password:')
	bd=Bd(username = 'adminNoDrop',
		#hostname = 'pds.telmex.com',
		hostname = 'localhost',
		password = pswd,
		database = 'pdstelmexpreprod',
		port=4002
		)

	print(bd.doQuery("SELECT USER() FROM DUAL;")[0])

	leeSerial()
