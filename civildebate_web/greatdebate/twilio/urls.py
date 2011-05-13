from django.conf.urls.defaults import *

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'greatdebate.views.home', name='home'),
    # url(r'^greatdebate/', include('greatdebate.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^vote/$', 'greatdebate.twilio.views.vote'),
    url(r'^latestChoice/$', 'greatdebate.twilio.views.latestChoice'),
    url(r'^allChoices/$', 'greatdebate.twilio.views.allChoices'),
    )