import re
import simplejson
import random
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import render_to_response
from django.template import RequestContext

from django.views.decorators.csrf import csrf_exempt

from greatdebate.vote.models import *
from greatdebate.twilio.models import *

"""
This is the view to which SMS votes are sent.
Message format should be 'A This is my comment' to vote for answer A.

Returns an SMS message informing about success, error or duplicate vote.
"""
@csrf_exempt
def vote(request):
    
    if request.POST:
        
        question = ActiveQuestions.objects.all()[0].question
        answers = question.answer_set.order_by("number")
    
        body = request.POST['Body']
        fromNumber = request.POST['From']
        
        txt = body
        
        # resA = re.search(r"^a (.*)", body, re.I)
#         resB = re.search(r"^b (.*)", body, re.I)
#         resC = re.search(r"^c (.*)", body, re.I)
#         
#         #answer = answers[0]
#         if resA is not None:
#             answer = answers[0]
#             txt = resA.group(1)
#         elif resB is not None:
#             answer = answers[1]
#             txt = resB.group(1)
#         elif resC is not None:
#             answer = answers[2]
#             txt = resC.group(1)
#         else:
        #return ender_to_response("vote_reply.xml", {"reply":"We did not understand your vote. Please try again."}, context_instance = RequestContext(request))
        
        phoneNumber, created = PhoneNumber.objects.get_or_create(number=fromNumber)
        
        try:
            SmsChoice.objects.create(question=question, answer=random.choice(answers), phone_number=phoneNumber, comment_text=txt)
            return render_to_response("vote_reply.xml", {"reply":"Thanks! Prepare to have your picture taken!"}, context_instance = RequestContext(request))
        except:
            return render_to_response("vote_reply.xml", {"reply":"You've already voted on this question!"}, context_instance = RequestContext(request))
        

    return render_to_response("vote_reply.xml", {"reply":"Something went wrong here."}, context_instance = RequestContext(request))
    
def get_choice_data(choice):

    d = {   'phone_number': {   'id': choice.phone_number.id, 'number': choice.phone_number.number },
            'choice':       {   'id': choice.id, 'question_id': choice.question.id, 'answer_number': choice.answer.number, 'comment_text': choice.comment_text} }
    
    return d
    
def latestChoice(request):
    
    choice = SmsChoice.objects.order_by('-date_created')[0]
    
    data = get_choice_data(choice)
    
    return HttpResponse(simplejson.dumps(data), mimetype='application/json')
    
def allChoices(request):
    
    choices = SmsChoice.objects.order_by('-date_created')
    
    alldata = []
    
    for choice in choices:
        data = get_choice_data(choice)
        alldata.append(data)
        
    return HttpResponse(simplejson.dumps(alldata), mimetype='application/json')
        
    