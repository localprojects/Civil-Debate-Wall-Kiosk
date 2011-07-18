import web
import datetime
import json
from web.contrib.webpy_mongodb_sessions.session import MongoStore
from web.contrib.webpy_mongodb_sessions import users

from pymongo.connection import Connection
from pymongo import json_util
from pymongo.son_manipulator import AutoReference, NamespaceInjector

from pymongo.objectid import ObjectId

import base64
import Image
import web.contrib.cropresize

urls = (
		'/test', 'test',
		
		'/debates/add', 'add_debate',
		'/debates/list', 'list_debates',
		'/debates/get', 'get_debate',		

		
		'/users/add', 'add_user',
		'/users/list', 'list_users',
		'/users/get', 'get_user',
		'/users/remove', 'remove_user',
		'/users/update', 'update_user',
		'/users/add-image', 'add_user_image',		

		
		
		'/questions/list', 'list_questions',
		'/questions/add', 'add_question',
		'/questions/get', 'get_question',		
		
    '/(.*)', 'hello'
)

app = web.application(urls, globals())

# Connect to MongoDB, manage references automatically
try:
    c = Connection("localhost", 27017)
except ConnectionFailure:
    print "Could not connect to database."
    sys.exit(1)

db = c.cdw
db.add_son_manipulator(NamespaceInjector())
db.add_son_manipulator(AutoReference(db))

# Store session info in MongoDB
session = web.session.Session(app, MongoStore(db, 'sessions'))

# Need these?
users.session = session
users.collection = db.users
users.SALTY_GOODNESS = u'RANDOM_SALT'

# Helper functions
def set_api_headers():
	web.header('Cache-Control', 'no-store, no-cache, must-revalidate')
	web.header('Content-Type', 'application/json')


# Views
class test:
	def GET(self):
		return 'test'

class hello:        
    def GET(self, name):
        if not name: 
            name = 'World'
        return 'Hello, ' + name + '!'


# DEBATES
class add_debate:
	def POST(self):
		# requires at least authorId, questionId, opinion, stance, and origin
		set_api_headers()
		i = web.input()
		
		# pull out references to the debate author and question to which he / she is responding
		author = db.users.find_one(ObjectId(i.authorId))
		question = db.questions.find_one(ObjectId(i.questionId))
		
		debate = {'author': author, 
							'question': question,
							'opinion': i.opinion,
							'stance': i.stance,
							'likes': 0,
							'origin': i.origin,
							'comments': list(),
							'created': datetime.datetime.utcnow()}
							
		return db.debates.save(debate)


class list_debates:
	def GET(self):
		set_api_headers()
		return json.dumps(list(db.debates.find()), default=json_util.default, sort_keys=False, indent=2)
		
class get_debate:
	def POST(self):
		set_api_headers()
		i = web.input()
		return json.dumps(db.debates.find_one(ObjectId(i.id)), default=json_util.default, sort_keys = False, indent = 2)


# USERS
class add_user:
	def POST(self):
		set_api_headers()
		i = web.input()

		user = {'firstName': i.firstName, 
						'lastName': i.lastName,
						'phoneNumber': i.phoneNumber,
						'origin': i.origin,
						'created': datetime.datetime.utcnow()}
						
		return db.users.save(user)
		
		
class get_user:
	def POST(self):
		set_api_headers()
		i = web.input()
		return json.dumps(db.users.find_one(ObjectId(i.id)), default=json_util.default, sort_keys = False, indent = 2)

class add_user_image:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		user = db.users.find_one(ObjectId(i.id))

		# set the image count based on number of existing photos
		image_count = 1;
		if 'photos' not in user:
			user['photos'] = []
		else:
			image_count = len(user['photos']) + 1

		original_filename = i.id + '-original-' + str(image_count) + '.' + i.format
		thumbnail_filename = i.id + '-thumbnail-' + str(image_count) + '.jpg'
		
		# save the original image file
		f = open('static/' + original_filename, 'wb')
		f.write(base64.b64decode(i.image))
		f.close()

		#todo pass in face data? crop more intelligently?
		#make a thumbnail	
		im = Image.open(f);
		thumbnail_image = cropresize.crop_resize(im, 71, 96);
		thumbnail_image.save('static/' + thumbnail_filename, 'JPEG', quality = 100)
		
		# updated the user's database entry, so we know where the files live
		user['photos'].append({
			'originalUrl': original_filename,
			'created':  datetime.datetime.utcnow()
		})
		
		return db.users.save(user)
		
class list_users:
	def GET(self):
		set_api_headers()
		return json.dumps(list(db.users.find()), default=json_util.default, sort_keys=False, indent=2)

class remove_user:
	def POST(self):
		set_api_headers()
		i = web.input()
		return db.users.remove(ObjectId(i.id))

class update_user:
	def POST(self):
		set_api_headers()
		i = web.input()

		# TODO more fields...
		user = db.users.find_one(ObjectId(i.id))		
		user['origin'] = i.origin
		user['modified'] = datetime.datetime.utcnow()
		return db.users.save(user)


# QUESTIONS
class list_questions:
	def GET(self):
		set_api_headers()
		#return db.questions.find()
		return json.dumps(list(db.questions.find()), default=json_util.default, sort_keys = False, indent = 2)

class add_question:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		author = db.users.find_one(ObjectId(i.authorId))
		
		question = {'question': i.question, 
								'author': author,
								'created': datetime.datetime.utcnow()}

		return db.questions.save(question)

class get_question:
	def POST(self):
		set_api_headers()
		i = web.input()
		return json.dumps(db.questions.find_one(ObjectId(i.id)), default=json_util.default, sort_keys = False, indent = 2)



if __name__ == "__main__":
    app.run()