from django.db import models
import django_facebook.models
from django.contrib.auth.models import User
from django.db.models.signals import *

# Create your models here.


class DebateFacebookProfile(django_facebook.models.FacebookProfileModel):
    """
    Holds all the FB data. Every user gets one as it's also the regular UserProfile module. 
    If their FB account is connected, this will hold ID and other data
    """
    description = models.TextField()
   

class LargeImage(models.Model):
    """
    Holds the large FB image.
    """
    profile = models.ForeignKey(DebateFacebookProfile)
    image = models.ImageField(upload_to="profile_images_large")



def create_profile(sender, instance, created, **kwargs):
    """
    Automatically create a FB profile when a User is saved
    """
    
    if created == True:
        try:
            DebateFacebookProfile.objects.get(user=instance)
        except:
            profile = DebateFacebookProfile(user=instance)
            profile.save()

post_save.connect(create_profile, sender=User)


class Question(models.Model):
    """
    Every question has a text and any number of answers.
    """
    text = models.CharField(max_length=280)
    date_created = models.DateTimeField(auto_now_add=True)
    
    def __unicode__(self):
        return self.text

class ActiveQuestions(models.Model):
    """
    This table should only contain ONE active question at a time.
    If we have multiple active questions, only the latest one will be chosen by various views.
    """
    question = models.ForeignKey(Question)

class Answer(models.Model):
    """
    Answer numbers are entered manually. If a Question has n Answers, the answer numbers should be {1, 2, ... n}
    In the templates, answer numbers 1-26 will be replaced by A-Z.
    """
    question = models.ForeignKey(Question)
    text = models.CharField(max_length=280)
    date_created = models.DateTimeField(auto_now_add=True)
    number = models.IntegerField(editable=True)
    
    def __unicode__(self):
        tx = self.text
        if len(tx) > 50:
            tx = tx[:50] + "..."
        return str(self.number ) + " (" + tx + ")"
 
class Choice(models.Model):
    """
    A Choice is a User's choice of an answer for a particular question. Every User can only pick one answer per question.
    It also holds that User's comment about the chosen answer.
    """   
    user = models.ForeignKey(User)
    question = models.ForeignKey(Question)
    answer = models.ForeignKey(Answer)
    comment_text = models.TextField()
    date_created = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ("user", "question")
        
    def __unicode__(self):
        return "%s --- %s --- %s" % (self.user, self.question, self.answer)


class Rating(models.Model):
    """
    A Rating is a User's rating of another User's Choice. 
    The actual rating value is either 0 (negative/disagree/unconstructive) or 1 (positive/agree/constructive).
    """
    user = models.ForeignKey(User)
    choice = models.ForeignKey(Choice)
    rating = models.IntegerField( choices = ( (0, 'Disagree'), (1,'Agree') ) )
    date_created = models.DateTimeField(auto_now_add=True)