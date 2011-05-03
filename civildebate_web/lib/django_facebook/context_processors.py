import django_facebook.settings as fbsettings

def facebook_app_id(request):
    return {'facebook_app_id': fbsettings.FACEBOOK_APP_ID}
