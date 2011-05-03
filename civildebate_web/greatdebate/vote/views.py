from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render_to_response, get_object_or_404, get_list_or_404, redirect
from django.template import RequestContext
from greatdebate.settings import FACEBOOK_APP_ID, FACEBOOK_APP_SECRET, BASE_URL, HOST_URL, MASKED_BASE_URL, MASKED_HOST_URL, MEDIA_ROOT, INSTALLATION_ROOT
from greatdebate.vote.models import *
from django_facebook.facebook_api import *
from django_facebook.facebook import *
from django_facebook.view_decorators import facebook_env
from django.contrib.auth import authenticate, login
from django.contrib.auth.views import logout
from django.contrib.auth.models import User
from greatdebate.vote.templatetags.vote_extras import nobadwords
from django import forms
from PIL import Image

import django.core.files
import django.core.files.temp
import urllib2
import os
import re
import datetime
import random
import json
import simplejson
import logging


LOG_FN = '%slog/greatdebate.vote.views.log' % (INSTALLATION_ROOT)

logger = logging.getLogger("vote.views")
logger.setLevel(logging.DEBUG)
lhandler = logging.handlers.RotatingFileHandler(LOG_FN, maxBytes=1048576, backupCount=10)
lhandler.setFormatter(logging.Formatter('%(asctime)s %(name)-12s %(levelname)-8s %(funcName)s@%(lineno)d %(message)s'))

logger.addHandler(lhandler)


class ChoiceForm(forms.Form):
    comment_text = forms.CharField(max_length=1024, min_length=1)
    answer_id = forms.ModelChoiceField(queryset=Answer.objects.all())
    question_id = forms.ModelChoiceField(queryset=Question.objects.all())


def vote_logout(request):
    """
    Currently only forwards to django-registration logout, but if we needed to do something
    with session or cookies, we could do it here
    """

    return logout(request, template_name="registration/logout.html")
    
    

def vote_login(request):
    """
    Regular (non-FB) login. 
    """

    if request.POST:
        rq_email = request.POST['email']
        rq_password = request.POST['password']
        
        users = User.objects.filter(email=rq_email)
        
        if len(users) == 1:
            rq_username = users[0]
        
            user = authenticate(username=rq_username, password=rq_password)
            
            if user is not None:
                if user.is_active:
                    login(request, user)
                    return redirect('main')
                else: # not active
                    return render_to_response("registration/login.html", {'error':'user is deactivated'}, context_instance=RequestContext(request))
            else: # authenticate failed
                return render_to_response("registration/login.html", {'error':'incorrect password'}, context_instance=RequestContext(request))
        else: # user-for-email returned is 0 (or > 1, but registration should prevent that)
            return render_to_response("registration/login.html", {'error':'no user with this email address found'}, context_instance=RequestContext(request))
    
    else: # GET
        return render_to_response("registration/login.html", context_instance=RequestContext(request))


@facebook_env
def index(request):
    """
    Main view.
    
    Pull the active question. If the user hasn't answered it, show it along with choices etc.
    If they have answered it, show their answer (variant of choice_details)
    """
    data = {}
    
    mode = 0
    if request.GET:
        try:
            mode = request.GET["mode"]
        except Exception:
            pass
        
   # data['question'] = Question.objects.all().order_by('-date_created')[0]
    data['question'] = ActiveQuestions.objects.all()[0].question
    
    if request.user.is_authenticated():
        data['user'] = request.user
        
        answered = Choice.objects.filter(user=request.user, question=data['question'])
        if len(answered) > 0:
            choice = answered[0]
            #data['question'] = False
            #data['noquestionsleft'] = True
            ratings = choice.rating_set.all()
            return render_to_response("choice_detail.html", {'choice': choice, 'ratings': ratings, 'author': True}, context_instance=RequestContext(request))
        else:
            data['answers_with_examples'] = []
            
            answers = data['question'].answer_set.order_by('number')
            
            for a in answers:
                choices = Choice.objects.filter(answer=a)
                if len(choices) > 0:
                    data['answers_with_examples'].append( {'answer': a, 'example': random.choice(choices)} )
                else:
                    data['answers_with_examples'].append( {'answer': a, 'example': None} )
                
        
    graph = request.facebook()
    fb = {}
    try:
        fbp = request.user.debatefacebookprofile
        if graph is not None and fbp is not None and fbp.facebook_id is not None:
            fb['img'] = 'https://graph.facebook.com/me/picture?access_token=%s' % graph.access_token
    except:
        fb = {}
     
    return render_to_response("django_facebook/connect.html", {'data': data, 'fb':fb, 'mode':mode}, context_instance=RequestContext(request))
    

def get_graph(request):
    """
    Returns a FB Graph object if the cookie is present, or None otherwise.
    """

    fuser = get_user_from_cookie(request.COOKIES, FACEBOOK_APP_ID, FACEBOOK_APP_SECRET)
    if fuser:
        graph = GraphAPI(fuser["access_token"])
        if graph:
            return graph
    
    return None
    
def friends(request):
    """
    Returns User's friends. Not used.
    """
    friends = {}
    
    graph = get_graph(request)
    
    if graph is not None:
        profile = graph.get_object("me")
        friends = graph.get_connections("me", "friends")

    return render_to_response("friends.html", {'user':request.user, 'friends': friends}, context_instance=RequestContext(request))
        

def get_choices_to_rate(request, q, a, min_choices_per_answer, max_choices_per_answer):
    """
    Get 1-2 choices for each of the answers other than the one we chose.
    I.e. if we chose A, show 1-2 B choices, and 1-2 C choices.
    Only consider choices we haven't rated yet.
    """
    # get all different choices
    diff_choices = Choice.objects.filter(question = q).exclude(answer__id=a.id).exclude(user=request.user)
    
    # only retain those we haven't rated yet
    other_choices = filter(lambda c : c not in Rating.objects.filter(user=request.user), diff_choices)
    
    # get distinct answers among those choices
    answers = set(map(lambda c : c.answer, other_choices))
    
    logger.debug(answers)
    
    # for each answer, choose 1-2 choices and append them to the choices_to_rate list
    choices_to_rate = []
    
    if(len(answers)==1):
        min_choices_per_answer = min_choices_per_answer + 1
        max_choices_per_answer = max_choices_per_answer + 1
        
    for i in range(len(answers)):
        curanswer = answers.pop()
        choices_for_curanswer = filter(lambda c : c.answer == curanswer, other_choices)
        
        sample_size = 1
        try:
            sample_size = random.randint(min_choices_per_answer, min(max_choices_per_answer, len(choices_for_curanswer)))
        except ValueError:
            sample_size = 1
        
        sample = random.sample(choices_for_curanswer, sample_size)
        choices_to_rate.extend(sample)
    
    logger.debug(choices_to_rate)

    return choices_to_rate

@facebook_env
def post_to_wall(request, choice_id):
    """
    Post the User's choice to their FB wall.
    Insert a link to the choice_details view into the FB post.
    """
    
    choice = Choice.objects.get(pk=choice_id)
    questiontext = choice.question.text
    answertext = choice.answer.text
    commenttext = choice.comment_text
    
    response = {}
    
    logger.debug(request)
    
    try:
        fb = request.facebook()
        logger.debug(fb)
        
    
        fbp = request.user.debatefacebookprofile
        if fb is not None and fbp is not None and fbp.facebook_id is not None:
            try:
                putresponse = fb.put_object("me", "feed", message="I voted in the Great Civil Debate. Check it out:",
                                    link="%s%s/vote/choice_details/%s" % (HOST_URL, BASE_URL, choice_id),
                                    picture="%s/static/img/debatelogo_2.jpg" % (HOST_URL),
                                    name="The Great Civil Debate",
                                    caption="This week's question: %s" % (questiontext.encode("ascii","ignore")),
                                    description="My answer: %s" % (answertext.encode("ascii","ignore"))
                                    )
            except Exception, err:
                logger.exception(str(err))
                
            response['success'] = True
            response['response'] = putresponse
        else:
            response['success'] = False
            logger.error("error posting to wall: %s / %s / %s" % (str(request.user), str(fb), str(fbp)))
    except Exception, err:
            response['success'] = False
            logger.exception(str(err))
    
    return HttpResponse(simplejson.dumps(response), mimetype='application/json')
            
        
def debug_del_choices(request):
    """
    Delete all of the User's choices and ratings. For debug purposes only.
    """
    c = Choice.objects.filter(user=request.user)
    c.delete()
    
    r = Rating.objects.filter(user=request.user)
    r.delete()
    
    return redirect("main")

def rate_choices(request):
    """
    Return a selection of other Users' choices to rate for the current User. Not used.
    """
    q = Question.objects.get(pk=request.GET["q"])
    a = Answer.objects.get(pk=request.GET["a"])
    choices_to_rate = get_choices_to_rate(request, q, a, 1, 2)
    response = {"choices_to_rate":choices_to_rate}
    return render_to_response("rate_full.html", {'response':response}, context_instance=RequestContext(request))

@facebook_env  
def submit_choice(request):
    """
    Submit choice to the DB.
    
    Returns JSON string with "success"=True/False, and, if true, "choice" (Choice) and "choices_to_rate" (Array of Choices).
    """

    hasFb = False
    
    if request.POST:

        form = ChoiceForm(request.POST)
        if form.is_valid():
        
            q = form.cleaned_data['question_id']
            a = form.cleaned_data['answer_id']
            comment = form.cleaned_data['comment_text']
        
            choice = Choice.objects.create(user=request.user, question=q, answer=a, comment_text=comment, date_created = datetime.datetime.now())

            choices_to_rate = get_choices_to_rate(request, q, a, 1, 2)
                        
            response = {"success":True,
                        "choice":choice,
                        "choices_to_rate" : choices_to_rate }

        else:
            response = {"success":False}
        
      #  return HttpResponse(simplejson.dumps(response), mimetype='application/json'
    return render_to_response("submit_choice_success.html", {'response':response, 'facebook':hasFB(request)}, context_instance=RequestContext(request))

def get_choice_stats(choice):
    """
    Get text, total votes, percentage of votes, and a height for vis purposes of a Choice.
    """
    
    stats = {}
    
    totalvotes = len(Choice.objects.filter(question=choice.question))
    
    for a in choice.question.answer_set.all():
        choices_for_a = Choice.objects.filter(answer=a)
        count = len(choices_for_a)
        perc = 100*float(count)/float(totalvotes)
        stats[a.number] = {'text' : a.text, 'count' : count, 'percent': perc, 'height':perc*3}
    
    return stats

def submit_rating(request):
    """
    Submit Rating to the DB.
    
    Returns JSON string with "success" = True.
    """

    if request.POST:
        post = request.POST
        p_choice = Choice.objects.get(pk=post['choice_id'])
        p_rating = post['rating']
        p_user= request.user
        
        rating = Rating.objects.create(user=p_user, choice=p_choice, rating=p_rating, date_created=datetime.datetime.now())
        
        #response = {"stats" : stats}
        
        return HttpResponse(simplejson.dumps({'success':True}), mimetype='application/json')

def hasFB(request):

    hasFb = False

    try:
        fb = request.facebook()
        fbp = request.user.debatefacebookprofile
        if fb is not None and fbp is not None and fbp.facebook_id is not None:
            hasFb = True
        else:
            hasFb = False
    except:
        hasFb = False
        
    return hasFb
    
 
@facebook_env     
def rating_finished(request, choice_id):
    """
    User has completed rating.
    
    Returns last page in the vote process.
    """
    
    ch = Choice.objects.get(pk=choice_id)
    stats = get_choice_stats(ch)

    return render_to_response("rating_finished.html", {'stats':stats, 'choice':Choice.objects.get(pk=choice_id), 'facebook':hasFB(request)}, context_instance=RequestContext(request))

def choice_detail(request, choice_id):
    """
    View details for a choice. This is linked from the FB posts.
    """
    
    choice = Choice.objects.get(pk = choice_id)
   
    ratings = choice.rating_set.all()
   
    return render_to_response("choice_detail.html", {'choice': choice, 'ratings': ratings}, context_instance=RequestContext(request))

    
@facebook_env
def fill_all_image_data(request):
    """
    Call manually.
    
    Fills all FB user's thumbnail images.
    """
    
    users = User.objects.all()
    
    resp = {}
    resp['result'] = "none"
    
    
    for user in users:
        try:
            fbp = user.debatefacebookprofile
            
            if fbp is not None and fbp.facebook_id is not None:
        
                imgurl = "http://graph.facebook.com/%d?fields=picture" % (fbp.facebook_id)
                opener1 = urllib2.build_opener()
                page1 = opener1.open(imgurl)
                img = page1.read()
                
                realurl = json.loads(img)["picture"]
                
                img_temp = django.core.files.temp.NamedTemporaryFile(delete=True)
                img_temp.write(urllib2.urlopen(realurl).read())
                img_temp.flush()
                
                filename = user.username + ".jpg"
                
                try:
                    fbp.image.delete(save=False)
                except Exception:
                    pass

                fbp.image.save(filename, django.core.files.File(img_temp))
                
                resp['result'] = resp['result'] + filename + " * " + fbp.image.url + "---"
        except Exception, err:
                resp['result'] = resp['result'] + str(err) + " /// "
    
    return HttpResponse(simplejson.dumps(resp), mimetype='application/json')


@facebook_env
def fill_all_image_data_large(request):
    """
    Call manually.
    
    Fills all FB user's large images.
    """
    
    users = User.objects.all()
    
    resp = {}
    resp['result'] = "none"
    
    
    for user in users:
        try:
            fbp = user.debatefacebookprofile
            
            if fbp is not None and fbp.facebook_id is not None:
        
                imgurl = "http://graph.facebook.com/%d?fields=picture&type=normal" % (fbp.facebook_id)
                opener1 = urllib2.build_opener()
                page1 = opener1.open(imgurl)
                img = page1.read()
                
                realurl = json.loads(img)["picture"]
                
                img_temp = django.core.files.temp.NamedTemporaryFile(delete=True)
                img_temp.write(urllib2.urlopen(realurl).read())
                img_temp.flush()
                
                im = Image.open(img_temp.name)
                im.thumbnail( (100, 100), Image.ANTIALIAS)
                im.save(img_temp.name, "JPEG")
                
                filename = user.username + ".jpg"
                
                li = 0
                try:
                    li = LargeImage.objects.filter(profile=fbp)[0]
                except Exception:
                    li = LargeImage.objects.create(profile=fbp)
                
                try:
                    li.image.delete(save=False)
                except Exception:
                    pass
                li.image.save(filename, django.core.files.File(img_temp))

                
                resp['result'] = resp['result'] + filename + " * " + li.image.url + "---"
        except Exception, err:
                resp['result'] = resp['result'] + str(err) + " /// "
    
    return HttpResponse(simplejson.dumps(resp), mimetype='application/json')


@facebook_env  
def fill_image_data(request):
    """
    Called on FB user login.
    
    Fills small and large user image with the current pic from FB.
    
    Returns a debug JSON string with image URLs.
    """
    
    resp = {'result' : ''}

    try:
        fb = request.facebook()
        
        fbp = request.user.debatefacebookprofile
        
        if fb is not None and fbp is not None and fbp.facebook_id is not None:
    
            ### large image
            
            imgurl = fb.facebook_profile_data()['image']
            
            img_temp = django.core.files.temp.NamedTemporaryFile(delete=True)
            img_temp.write(urllib2.urlopen(imgurl).read())
            img_temp.flush()
            
            im = Image.open(img_temp.name)
            im.thumbnail( (100, 100), Image.ANTIALIAS)
            im.save(img_temp.name, "JPEG")
            
            filename = request.user.username + ".jpg"

            li = 0
            try:
                li = LargeImage.objects.filter(profile=fbp)[0]
            except Exception:
                li = LargeImage.objects.create(profile=fbp)
            
            try:
                li.image.delete(save=False)
            except Exception:
                pass
            li.image.save(filename, django.core.files.File(img_temp))
            
            
            ### small image
            
            imgurl = "http://graph.facebook.com/%d?fields=picture" % (fbp.facebook_id)
            opener1 = urllib2.build_opener()
            page1 = opener1.open(imgurl)
            img = page1.read()
                
            realurl = json.loads(img)["picture"]
                
            img_temp = django.core.files.temp.NamedTemporaryFile(delete=True)
            img_temp.write(urllib2.urlopen(realurl).read())
            img_temp.flush()
                
            filename = request.user.username + ".jpg"
                
            try:
                fbp.image.delete(save=False)
            except Exception:
                pass
            fbp.image.save(filename, django.core.files.File(img_temp))

            resp['result'] = resp['result'] + filename + " : " + li.image.url + ", " + fbp.image.url
        else:
            resp['result'] = "No Facebook profile found"
            
    except Exception, err:
            resp['result'] = str(err)
            
    logger.debug(request.user.username + " - updating images: " + resp['result'])
    
    return HttpResponse(simplejson.dumps(resp), mimetype='application/json')


def vis_data(request):
    """
    Get visualization data for active question.
    
    Called from the Processing app.
    """
    #question = Question.objects.all()[0]
    question = ActiveQuestions.objects.all()[0].question
    answers = question.answer_set.order_by("number")
    totalvotes = len(Choice.objects.filter(question=question))
    
    data = {}
    data["question"] = {"text" : question.text, "id" : question.id}
    data["totalvotes"] = totalvotes
    data["answers"] = []
    
    for a in answers:
        dct = {}
        dct["text"] = a.text
        dct["numchoices"] = len(Choice.objects.filter(answer=a))
        data["answers"].append(dct)
        
    return HttpResponse(simplejson.dumps(data), mimetype='application/json')
        
def vis_choice(request, question_id):
    """ 
    Vis data for a single choice.
    
    Called from the Processing app.
    """
    
    choice = 0
    try:
        cid = request.GET["choiceid"]
        choice = Choice.objects.get(pk=cid)
    except:
        while True:
            choice = random.choice(Choice.objects.filter(question__id = question_id))
            txt = choice.comment_text
            laziness = re.search("( Enter your answer here )", txt)
            if laziness is None:
                break
    
    data = {}
    data["choice_id"] = choice.id
    data["user_firstname"] = choice.user.first_name
    data["user_lastname"] = choice.user.last_name
    img = None
    try:
        #img = choice.user.debatefacebookprofile.image.url
        li = LargeImage.objects.filter(profile=choice.user.debatefacebookprofile)[0]
        img = li.image.url
    except Exception, err:
        data["EXC"] = str(err)
    
    data["user_imgurl"] = img
    data["answer_id"] = choice.answer.id
    data["answer_number"] = choice.answer.number
    data["answer_comment_text"] = nobadwords(choice.comment_text)
    
    positive = Rating.objects.filter(choice=choice, rating=1)
    
    # count the positive ratings the choice got. for each answer, select only those ratings that have been made by a user who chose this
    # answer to the question. for each such rating, increase the count for the rating for the current answer by 1
    positive_per_answer = []
    i = 0
    for a in choice.question.answer_set.all():
        positive_per_answer.append(0)
        for r in positive:
            if len(Choice.objects.filter(answer=a, user=r.user)) > 0:
               positive_per_answer[i] = positive_per_answer[i] + 1
        i = i + 1
    
    data["positive_ratings_per_answer"] = positive_per_answer 
    
    # now make the #th most constructive of total votes on this question
    question = choice.question
    
    allchoices = Choice.objects.filter(question = question)
    
    constructiveness_ranking = []
    for c in allchoices:
        rat = Rating.objects.filter(choice = c, rating = 1)
        rat = filter(lambda x : len(x.user.choice_set.filter(question = question)) > 0, rat)
        numpositive = len( rat )
        constructiveness_ranking.append( (c.id, numpositive) )
    
    constructiveness_ranking_sorted = sorted(constructiveness_ranking, key = lambda x : x[1], reverse=True)
    rank = 999999
    i = 0
    for item in constructiveness_ranking_sorted:
        if item[0] == choice.id:
            rank = i
        i = i + 1
    
    data["constructiveness_rank"] = rank
    data["constructiveness_ranking"] = constructiveness_ranking_sorted
    
    gender = 'n'
    try:    
        imgurl = "http://graph.facebook.com/%d" % (choice.user.debatefacebookprofile.facebook_id)
        opener1 = urllib2.build_opener()
        page1 = opener1.open(imgurl)
        img = page1.read()
                    
        gender = json.loads(img)["gender"]
    except Exception, err:
        data["exception"] = str(err)
    
    data["user_gender"] = gender
    
    return HttpResponse(simplejson.dumps(data), mimetype='application/json')
    