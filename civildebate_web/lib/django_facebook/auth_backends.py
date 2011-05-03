from django.contrib.auth import backends
from django.contrib.contenttypes.models import ContentType
from django.conf import settings

import logging

LOG_FILENAME = '/home/ubuntu/log/debate.log'

logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG)

class FacebookBackend(backends.ModelBackend):
    def authenticate(self, facebook_id, facebook_email):
        '''
        Authenticate the facebook user by id AND facebook_email
        '''
        try:
            profile_string = settings.AUTH_PROFILE_MODULE
            logging.debug("AUTH:::")
            logging.debug(profile_string)
            profile_model = profile_string.split('.')
            logging.debug("AUTH:::")
            logging.debug(profile_model)
            profile_class = ContentType.objects.get(app_label=profile_model[0].lower(), model=profile_model[1].lower())
            logging.debug("AUTH:::")
            logging.debug(profile_class)
            profile = profile_class.get_object_for_this_type(facebook_id=facebook_id, user__email=facebook_email)
            logging.debug("AUTH:::")
            logging.debug(facebook_id)
            logging.debug(facebook_email)
            logging.debug(profile)
            return profile.user
        except:
            return None
