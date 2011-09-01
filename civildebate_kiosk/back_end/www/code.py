import web
import datetime
import json
import pymongo
from webpy_mongodb_sessions.session import MongoStore
from webpy_mongodb_sessions import users
from pymongo.connection import Connection
from pymongo import json_util
from pymongo.son_manipulator import AutoReference, NamespaceInjector
from pymongo.objectid import ObjectId
import base64
from PIL import Image
import cropresize
from twilio.util import RequestValidator
from twilio.rest import TwilioRestClient

urls = (
		'/test', 'test',
		
		'/api/debates/add', 'add_debate',
		'/api/debates/list', 'list_debates',
		'/debates/get', 'get_debate',
		'/debates/update', 'update_debate',
		'/debates/remove', 'remove_debate',
		'/api/debates/like', 'like_debate',
		'/api/debates/flag', 'flag_debate',
		
		
		'/api/comments/add', 'add_comment',
		
		'/api/sms/receive', 'sms_receive',
		'/api/sms/status', 'sms_status',
		
		'/api/sms/latest', 'sms_latest',

		'/users/add', 'add_user',
		'/users/list', 'list_users',
		'/users/get', 'get_user',
		'/users/remove', 'remove_user',
		'/users/update', 'update_user',
		'/users/add-image', 'add_user_image',		
		'/api/users/add-or-update', 'add_or_update_user',				
		'/api/users/exists', 'check_for_user',
		
		'/api/stats/get', 'get_stats',		
		
		
		
		'/questions/list', 'list_questions',
		'/questions/add', 'add_question',
		'/api/questions/get', 'get_question',
		
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
    	return web.ctx.env
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
		author = db.users.find_one(ObjectId(i.author))
		question = db.questions.find_one(ObjectId(i.question))
		
		debate = {'author': author, 
							'question': question,
							'opinion': i.opinion,
							'stance': i.stance,
							'likes': 0,
							'flags': 0,
							'origin': i.origin,
							'comments': list(),
							'created': datetime.datetime.utcnow()}
							
		return db.debates.save(debate)


class list_debates:
	def GET(self):
		set_api_headers()
		return json.dumps(list(db.debates.find().sort('created', pymongo.DESCENDING)), default=json_util.default, sort_keys=False, indent=2)
		
	def POST(self):
		set_api_headers()
		i = web.input()

		if 'question' in i:
			# ignore the question field, per http://www.mongodb.org/display/DOCS/Retrieving+a+Subset+of+Fields
			debates = db.debates.find({'question.$id': ObjectId(i.question)}, {'question': 0 })
					
			return json.dumps(list(debates), default=json_util.default, sort_keys=False, indent=2)					
		
		
class get_debate:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		if 'id' in i:		
			return json.dumps(db.debates.find_one(ObjectId(i.id)), default=json_util.default, sort_keys=False, indent=2)
		else:
			return 'No debate ID specified'

class update_debate:
	def POST(self):
		set_api_headers()
		i = web.input()
			
		if 'id' in i:
			debate = db.debates.find_one(ObjectId(i.id))			
			
			if 'origin' in i: debate['origin'] = i.origin
			if 'likes' in i: debate['likes'] = i.likes
			if 'stance' in i: debate['stance'] = i.stance
			if 'question' in i: debate['question'] = i.question
			if 'author' in i: debate['author'] = db.users.find_one(ObjectId(i.author))
			if 'opinion' in i: debate['opinion'] = i.opinion
			if 'question' in i: debate['question'] = db.questions.find_one(ObjectId(i.question))		
			# TODO comments
			
			debate['modified'] = datetime.datetime.utcnow()		
			
			return db.debates.save(debate)
		
		else:
			return 'No debate ID specified'


class remove_debate:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		if 'id' in i:
			return db.debates.remove(ObjectId(i.id))
		else:
			return 'No debate ID specified'


class like_debate:
	def POST(self):
		set_api_headers()
		i = web.input()

		if 'id' in i:

			debate = db.debates.find_one(ObjectId(i.id))
			debate['likes'] = debate['likes'] + 1
			debate['modified'] = datetime.datetime.utcnow()
			db.debates.save(debate)
			return str(debate['likes'])
		else:
			return 'No debate ID specified'
			
			
class flag_debate:
	def POST(self):
		set_api_headers()
		i = web.input()

		if 'id' in i:

			debate = db.debates.find_one(ObjectId(i.id))
			debate['flags'] = debate['flags'] + 1
			debate['modified'] = datetime.datetime.utcnow()
			db.debates.save(debate)
			return str(debate['flags'])
		else:
			return 'No debate ID specified'			

# Comments
class add_comment:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		if 'debate' in i:
						
			# add it to the list of comments in the original debate
			author = db.users.find_one(ObjectId(i.author))
	
			comment = {'author': author, 
								 'debate': i.debate, # JUST THE ID, not a dbref, otherwise we get a circular reference condition
								 'question': i.question, # JUST THE ID, not a dbref, otherwise we get a circular reference condition
								 'comment': i.comment,
								 'stance': i.stance,
								 'flags': 0,
								 'origin': i.origin,
								 'created': datetime.datetime.utcnow()}

			comment_id = db.comments.save(comment)
			new_comment = db.comments.find_one(ObjectId(comment_id))	
			
			# add reference in original debate
			debate = db.debates.find_one(ObjectId(i.debate))			
			
			if debate['comments'] is None:
				debate['comments'] = []
				
			debate['comments'].append(new_comment)
			
			db.debates.save(debate)
			
			return comment_id

# SMS
# TODO store messages received and statuses in different collections?
class sms_receive:
	def POST(self):
		set_api_headers()
		i = web.input()


		if i:
			# validate
			ACCOUNT_SID = 'AC758bf16fe0a49b5b12dd6d7b2bbf8a73'
			AUTH_TOKEN = 'b58daf22df0816a600dd99abf3d35bd4'
			validator = RequestValidator(AUTH_TOKEN)
			url = 'http://ec2-50-19-25-31.compute-1.amazonaws.com/api/sms/receive'
			signature = web.ctx.env.get('HTTP_X_TWILIO_SIGNATURE', 'none')
	
			if validator.validate(url, i, signature):
				i['valid'] = True
			else:
				i['valid'] = False

			i['created'] = datetime.datetime.utcnow()
			
			# log to DB
			# an SMS log is also accessible throuigh Twilio's REST API,
			# but faster / simpler / more reliable to duplicate it on our end
			db.smsReceived.save(i)
			
			# TODO figure out what to do and how to respond

			# respond
			client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)
			message = client.sms.messages.create(to=i['From'], from_=i['To'], body='response!')

		return ''
		
		
class sms_status:
	def POST(self):
		set_api_headers()
		i = web.input()

		if i:
			i['type'] = 'status'
			i['created'] = datetime.datetime.utcnow()
			db.smsStatus.save(i)

		return ''		

class sms_latest:
	def GET(self):
		set_api_headers()

		#db.smsReceived.create_index('created')
		most_recent_sms = db.smsReceived.find().sort('created', pymongo.DESCENDING).limit(1)

		return json.dumps(most_recent_sms[0], default=json_util.default, sort_keys = False, indent = 2)


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



class add_or_update_user:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		# get or create the user object
		if 'id' in i:
			# update user with id
			user = db.users.find_one(ObjectId(i.id))
			
		elif 'phoneNumber' in i:
			# add or update user with phone bumber
			user = db.users.find_one({'phoneNumber': i.phoneNumber})
			
			if user is None:
				# create a new user, will get this phone number
				user = {} 
				user['created'] = datetime.datetime.utcnow()

		else:
			# create a new user user
			user = {}
			user['created'] = datetime.datetime.utcnow()
					
		# set fields
		for field in i:
			user[field] = i[field]

		user['modified'] = datetime.datetime.utcnow()
		
		id = db.users.save(user)		
		return json.dumps(db.users.find_one(ObjectId(id)), default=json_util.default, sort_keys = False, indent = 2)



class get_user:
	def POST(self):
		set_api_headers()
		i = web.input()
		return json.dumps(db.users.find_one(ObjectId(i.id)), default=json_util.default, sort_keys = False, indent = 2)


class add_user_image:
	def POST(self):
		set_api_headers()
		i = web.input()
		
		# TODO S3 and NAS
		
		
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
		f = open('/var/www/static/' + original_filename, 'wb')
		f.write(base64.b64decode(i.image))
		f.close()

		#todo pass in face data? crop more intelligently?
		#make a thumbnail	
		im = Image.open('/var/www/static/' + original_filename);
		thumbnail_image = cropresize.crop_resize(im, (71, 96));
		thumbnail_image.save('/var/www/static/' + thumbnail_filename, 'JPEG', quality = 100)

		# updated the user's database entry, so we know where the files live
		user['photos'].append({
			'originalUrl': original_filename,
			'thumbnailUrl': thumbnail_filename,
			'created':  datetime.datetime.utcnow()
		})
		
		return db.users.save(user)

class check_for_user:
	def POST(self):
		set_api_headers()
		i = web.input()
		return json.dumps(db.users.find_one({'phoneNumber': i.phoneNumber}), default=json_util.default, sort_keys=False, indent=2) 
		
		
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

		user = db.users.find_one(ObjectId(i.id))	
		
		for field in i:
			user[field] = i[field]
		
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
		
		author = db.users.find_one(ObjectId(i.author))
		
		question = {'question': i.question, 
								'author': author,
								'created': datetime.datetime.utcnow()}

		return db.questions.save(question)


class get_question:
	def POST(self):
		set_api_headers()
		i = web.input()
		return json.dumps(db.questions.find_one(ObjectId(i.id)), default=json_util.default, sort_keys = False, indent = 2)
		
class get_stats:
	def POST(self):
		set_api_headers()
		i = web.input()
		question_id = i.id;
		
		stats = dict()		
		# total votes
				
		# ignore the question field, per http://www.mongodb.org/display/DOCS/Retrieving+a+Subset+of+Fields
		debates = db.debates.find({'question.$id': ObjectId(question_id)}, {'stance': 1, 'opinion': 1, 'likes': 1, 'comments': 1})
		comments = db.comments.find({'question': question_id}, {'stance': 1, 'opinion': 1})		
				
		#return debates		
		yes_debate_count = 0
		no_debate_count = 0
		yes_likes = 0
		no_likes = 0
		
		mostDebatedOpinions = list()
		
		for debate in debates:
			mostDebatedOpinions.append({'id': str(debate['_id']), 'commentCount': len(debate['comments'])})
			
			if debate['stance'] == 'yes':
				yes_debate_count += 1
				yes_likes += debate['likes']
			else:
				no_debate_count += 1
				no_likes += debate['likes']

						
		# comments can't have likes		
		for comment in comments:
			if comment['stance'] == 'yes':
				yes_debate_count += 1
			else:
				no_debate_count += 1				
		
		
		
		
		# what happens to the list after iterating? weird. have to grab it again
		debates = db.debates.find({'question.$id': ObjectId(question_id)}, {'stance': 1, 'opinion': 1, 'likes': 1, 'comments':1})
		
		# {word: {count: 132, threads: ['35234234', '234234234', '23423434'], yesCases: 234, noCases: 342} word: }
		# most frequently used words
		words = dict()

		for debate in debates:
			# the first post
			debateID = debate['_id']
			stance = debate['stance']
			
			# first from the debate starter
			for word in debate['opinion'].split():
				if word not in words:
					words[word] = {'threads': [str(debateID)], 'yesCases': 0, 'noCases': 0, 'total': 0}
				else:
					words[word]['threads'].append(str(debateID))
				
				words[word]['total'] += 1
				
				if stance == 'yes':
					words[word]['yesCases'] += 1
				else:	
					words[word]['noCases'] += 1				
			
			# then from the comments
			for comment in debate['comments']:
				stance = comment['stance']
			
				for word in comment['comment'].split():
					if word not in words:
						words[word] = {'threads': [str(debateID)], 'yesCases': 0, 'noCases': 0, 'total': 0}
					else:
						if str(debateID) not in words[word]['threads']:
							words[word]['threads'].append(str(debateID))
					
					words[word]['total'] += 1
					
					if stance == 'yes':
						words[word]['yesCases'] += 1
					else:	
						words[word]['noCases'] += 1	
					
		
		# turn the dictionary into a list of objects so we can sort it
		wordList = list()
		
		for word in words:
			words[word]['word'] = word
			wordList.append(words[word])
			
				
		# for every word, a list of debate threads where it appears		
		sortedWordList = sorted(wordList, key=lambda k: k['total'])
		sortedWordList.reverse() # biggest first

		
		
		# most liked debates
		likedDebates = db.debates.find({'question.$id': ObjectId(question_id)}, {'likes': 1}).sort('likes', pymongo.DESCENDING).limit(5)		
		
		liked = list()
		for debate in likedDebates:
			liked.append({'id': str(debate['_id']), 'likes': int(debate['likes'])})
			
		

		# most debated opinions
		# gathered in the first for loop
		mostDebatedOpinions = sorted(mostDebatedOpinions, key=lambda k: k['commentCount'])
		mostDebatedOpinions.reverse() # biggest first		
		
		# gather and return
		
		stats['debateTotals'] = {'yes': int(yes_debate_count), 'no': int(no_debate_count)}
		stats['likeTotals'] = {'yes': int(yes_likes), 'no': int(no_likes)}		
		stats['frequentWords'] = sortedWordList[0:20] # only the top 20
		stats['mostLikedDebates'] = liked # only the top 5
		stats['mostDebatedOpinions'] = mostDebatedOpinions[0:5] # only the top 5
		
		
		
		return json.dumps(stats, default=json_util.default, sort_keys=False, indent=2)			

		

# 		mostFrequentWords: [{word: 'someWord', threads: [debateID], yesRatio: 0.4}, {word: 'someWord', thread: debateID, yesRatio: 0.4}],
# 		mostDebatedOpinions: [debateID, debateID], // number of responses
# 		mostLikedOpinions: [debateID, debateID], // # of likes
# 		mostActiveUsers: [
# 		 Most active users (measured by total number of posts)
# 		}

		
		
		
		return 'stats!'
		
		return json.dumps(db.questions.find_one(ObjectId(i.id)), default=json_util.default, sort_keys = False, indent = 2)
		

if __name__ == "__main__":
    app.run()    
	
app = web.application(urls, globals(), autoreload=False) # ammended for mod_wsgi
#app.notfound = notfound	
application = app.wsgifunc()