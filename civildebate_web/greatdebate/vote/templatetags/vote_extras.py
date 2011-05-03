from django import template
import re

register = template.Library()

@register.filter(name='numtoletter')
def numtoletter(value):
    return "ABCDEFGHIKLMNOPQRSTUVWXYZ"[value%26]
    
@register.filter(name='max32')
def max32(value):
    return re.sub('[^\ ]{32,}', lambda x : x.group(0)[:31], value)
    
@register.filter(name='nobadwords')
def nobadwords(value):
    f = open("/home/ubuntu/data/profanities.txt","r")
    profs = f.read().split(" ")
    
    # uncomment for whole-word only
    profs = map(lambda p : "\\b"+p+"\\b", profs)
    
    prof = "|".join(profs)
    return re.sub(prof, "%!$#^@", value)