from greatdebate.settings import BASE_URL, HOST_URL, MASKED_BASE_URL, MASKED_HOST_URL, FACEBOOK_APP_ID

def vote_context(request):
    return {'facebook_app_id': FACEBOOK_APP_ID, 'base_url' : BASE_URL, 'host_url' : HOST_URL, 'masked_base_url' : MASKED_BASE_URL, 'masked_host_url' : MASKED_HOST_URL }