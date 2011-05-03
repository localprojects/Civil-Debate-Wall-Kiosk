from django.contrib import admin

from greatdebate.vote.models import *



class AnswerInline(admin.StackedInline):
    model = Answer
    extra = 3

class QuestionAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['text']}),
    ]
    inlines = [AnswerInline]
    list_display = ('text', 'date_created')
    
class ChoiceAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['user', 'question', 'answer', 'comment_text']}),
    ]
    list_display = ('question', 'user', 'answer', 'date_created')
    
class RatingAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['user', 'choice', 'rating']}),
    ]
    list_display = ('choice_question', 'user', 'choice_user', 'choice_comment_text')
    
    def choice_question(self, obj):
        return obj.choice.question
    
    def choice_user(self, obj):
        return obj.choice.user
        
    def choice_comment_text(self, obj):
        return obj.choice.comment_text
    
admin.site.register(DebateFacebookProfile)
admin.site.register(Question, QuestionAdmin)
admin.site.register(Choice, ChoiceAdmin)
admin.site.register(Rating, RatingAdmin)
admin.site.register(ActiveQuestions)