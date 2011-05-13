from django.db import models
import greatdebate.vote.models

# Create your models here.

class PhoneNumber(models.Model):
    number = models.CharField(max_length=20)
    date_created = models.DateTimeField(auto_now_add=True)
    
    def __unicode__(self):
        return str(self.number)

class SmsChoice(models.Model):
    phone_number = models.ForeignKey(PhoneNumber)
    question = models.ForeignKey(greatdebate.vote.models.Question)
    answer = models.ForeignKey(greatdebate.vote.models.Answer)
    date_created = models.DateTimeField(auto_now_add=True)
    comment_text = models.CharField(max_length=140)
    
    def __unicode__(self):
        return "%s : %s (%s)" % ( str(self.question), str(self.answer), str(self.phone_number) )
    
    class Meta:
        unique_together = ("phone_number", "question")
    