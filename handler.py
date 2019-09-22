from datetime import datetime
import praw, pymysql, sys

reddit = praw.Reddit(client_id='CLIENT_ID',
                     client_secret='CLIENT_SECRET',
                     password='PASSWORD',
                     user_agent='/r/CFB Game Thread Indexer by /u/thecravenone',
                     username='USERNAME')

db = pymysql.connect("HOSTNAME", "DB_USER", "DB_PASSWORD", "DB_NAME")
# db = pymysql.connect("HOSTNAME", "DB_USER", "DB_PASSWORD", "DB_NAME")
cursor = db.cursor()

# Get the current week number
cursor.execute("SELECT value FROM config WHERE setting = 'week'")
row = cursor.fetchone()
week = row[0]

def log(input):
	stamp = str(datetime.now())
	print(stamp + " " + input)

def create_thread():
	thread_title = "Week " + week + " Game Thread and Postgame Thread Index"
	try:
		the_thread = reddit.subreddit('cfb').submit(thread_title, selftext="Automatically populating this thread. Please stand by...")
	except Error as error:
		log(error)
	else:
		id = the_thread.id
		setting = "week" + week + "thread"
		query = "INSERT INTO config(setting, value) VALUES (%s, %s)"
		data = (setting, id)
		cursor.execute(query, data)
		db.commit()
		log("Succesfully posted week " + week + " thread to https://redd.it/" + id)

def increment_week():
	new_week = str(int(week) + 1)
	query = "UPDATE config SET value = %s WHERE setting = 'week'"
	data = (new_week)
	try:
		cursor.execute(query, data)
		db.commit()
	except Error as error:
		log(error)
	else:
		log("Succesfully incremented from week " + week + " to week " + new_week)
	finally:
		cursor.close()
		db.close()

# MAIN EXECUTION:

import sys

if len(sys.argv) != 2:
	print("This script requires exactly one argument")
elif sys.argv[1] == "--post":
	create_thread()
	sys.exit()
elif sys.argv[1] == "--incrementweek":
	increment_week()
	sys.exit()
else:
	print("Unsupported argument detected.")
