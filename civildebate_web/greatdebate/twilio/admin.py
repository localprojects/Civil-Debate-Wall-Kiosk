from django.contrib import admin

from greatdebate.twilio.models import *

class SmsChoiceAdmin(admin.ModelAdmin):
    fieldsets = [
        (None,               {'fields': ['phone_number', 'question', 'answer', 'comment_text']}),
    ]
    list_display = ('question', 'phone_number', 'answer', 'date_created')

admin.site.register(SmsChoice, SmsChoiceAdmin)
admin.site.register(PhoneNumber)