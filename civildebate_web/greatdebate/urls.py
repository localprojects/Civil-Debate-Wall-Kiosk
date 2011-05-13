from django.conf.urls.defaults import patterns, include, url
from registration.views import register
from greatdebate.vote.forms import *
import greatdebate.vote.views

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',

    url(r'^admin/', include(admin.site.urls)),
    
    # vote is the main app
    url(r'^vote/', include('greatdebate.vote.urls')),
    url(r'^twilio/', include('greatdebate.twilio.urls')),
    url(r'^$', include('greatdebate.vote.urls')),
    
    # forwarding to custom login functions
    url(r'^accounts/login/$', greatdebate.vote.views.vote_login),
    url(r'^accounts/logout/$', greatdebate.vote.views.vote_logout),
    
    # using django-registration
    url(r'^accounts/register/$', register, {'form_class':VoteRegistrationForm, 'success_url':'complete/'}),
    url(r'^accounts/', include('registration.urls')),
    
    # using django-facebook
    url(r'^facebook/', include('django_facebook.urls')),
)
