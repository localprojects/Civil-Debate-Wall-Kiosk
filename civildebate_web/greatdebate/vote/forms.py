from registration.forms import RegistrationFormUniqueEmail
from registration.models import *
from django import forms

class VoteRegistrationForm(RegistrationFormUniqueEmail):
    firstname = forms.CharField(max_length=64, min_length=1)
    lastname = forms.CharField(max_length=64, min_length=1)
    
    def save(self, profile_callback=None):
    
        new_user = RegistrationProfile.objects.create_active_user(username=self.cleaned_data['email'],
                                                                    password=self.cleaned_data['password1'],
                                                                    email=self.cleaned_data['email'],
                                                                    profile_callback=profile_callback)
        
        
        new_user.first_name = self.cleaned_data['firstname']
        new_user.last_name = self.cleaned_data['lastname']
        new_user.save()
        
        return new_user