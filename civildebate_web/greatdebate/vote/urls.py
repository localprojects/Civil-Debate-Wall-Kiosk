from django.conf.urls.defaults import *
from django.views.generic.simple import direct_to_template

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'greatdebate.views.home', name='home'),
    # url(r'^greatdebate/', include('greatdebate.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    url(r'^$', 'greatdebate.vote.views.index', name='main'),
    url(r'^submit_choice/$', 'greatdebate.vote.views.submit_choice'),
    url(r'^friends/$', 'greatdebate.vote.views.friends'),
    url(r'^rate_choices/$', 'greatdebate.vote.views.rate_choices'),
    url(r'^submit_rating/$', 'greatdebate.vote.views.submit_rating'),
    url(r'^rating_finished/(?P<choice_id>.*)/$', 'greatdebate.vote.views.rating_finished'),
    url(r'^post_to_wall/(?P<choice_id>.*)/$', 'greatdebate.vote.views.post_to_wall'),
    url(r'^choice_details/(?P<choice_id>.*)/$', 'greatdebate.vote.views.choice_detail', name='details'),
    url(r'^about/$',direct_to_template, {'template': 'about.html'}),
    url(r'^privacypolicy/$',direct_to_template, {'template': 'privacypolicy.html'}),
    
    url(r'^reset/$', 'greatdebate.vote.views.debug_del_choices'),
    url(r'^fbimg/$', 'greatdebate.vote.views.fill_image_data'),
    url(r'^allfbimg/$', 'greatdebate.vote.views.fill_all_image_data'),
    url(r'^allfbimg_l/$', 'greatdebate.vote.views.fill_all_image_data_large'),
    
    url(r'^vis_data/$', 'greatdebate.vote.views.vis_data'),
    url(r'^vis_choice/(?P<question_id>.*)/$', 'greatdebate.vote.views.vis_choice'),
    
    
    )