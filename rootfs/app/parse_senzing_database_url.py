#! /usr/bin/env python

import os
import json
# from uritools import uricompose, urijoin, urisplit, uriunsplit
from urlparse import urlparse
# from urlparse import urlsplit
# import urllib

# https://www.ietf.org/rfc/rfc1738.txt

safe_character_map = {
    '$': 0,
    '-': 1,
    '_': 2,
    '.': 3,
    '+': 4,
    '!': 5,
    '*': 6,
    '(': 7,
    ')': 8,
    ',': 9,
    '"': 10,    
}

# https://www.ietf.org/rfc/rfc1738.txt

unsafe_character_map = {
    '"': "1",
    '<': "2",
    '>': "3",
    '#': "4",
    '%': "5",
    '{': "6",
    '}': "7",
    '|': "8",
    '\\': "9",
    '^': "10",
    '~': "11",
    '[': "12",
    ']': "13",
    '`': "14",
}    

reserved_character_map = {
    ';': 1,
    ',': 2,
    '/': 3,
    '?': 4,
    ':': 5,
    '@': 6,
    '=': 7,
    '&': 8,     
}



def translate(map, string):
    new_string = str(string)
    for key, value in map.items():
        new_string = new_string.replace(key, value)
    return new_string
        
def get_unsafe_characters(string): 
    result = []
    for unsafe_character in unsafe_character_map.keys():
        if unsafe_character in string:
            result.append(unsafe_character)
    return result
       
def get_safe_characters(string): 
    result = []
    for safe_character in safe_character_map.keys():
        if safe_character not in string:
            result.append(safe_character)
    return result
    
# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------    

if __name__ == "__main__":

    result = {}

    original_senzing_database_url = os.environ.get('SENZING_DATABASE_URL')
    original_senzing_database_url = "db2://user999:w#lQ%4e_Q04i-5PF@10.176.116.159:31081/AESEDB"
    
    senzing_database_url = original_senzing_database_url
    # senzing_database_url = "db2://user999:wlQ4e_Q04i-5PF@10.176.116.159:31081/AESEDB"
    
    # Create lists of safe and unsafe characters.
    
    unsafe_characters = get_unsafe_characters(senzing_database_url)
    safe_characters = get_safe_characters(senzing_database_url)
        
    # Perform translation.
        
    translation_map = {}
    safe_characters_index = 0     
    for unsafe_character in unsafe_characters:
        safe_character = safe_characters[safe_characters_index]
        safe_characters_index += 1
        translation_map[safe_character] = unsafe_character
        senzing_database_url = senzing_database_url.replace(unsafe_character, safe_character)
        
    # Parse "translated" URL.
        
    parsed = urlparse(senzing_database_url)
    schema = parsed.path.strip('/')
    
    # Construct result.
    
    result = {
        'scheme': translate(translation_map, parsed.scheme),
        'netloc': translate(translation_map, parsed.netloc),
        'path': translate(translation_map, parsed.path),
        'params': translate(translation_map, parsed.params),
        'query': translate(translation_map, parsed.query),
        'fragment': translate(translation_map, parsed.fragment),
        'username': translate(translation_map, parsed.username),
        'password': translate(translation_map, parsed.password),
        'hostname': translate(translation_map, parsed.hostname),
        'port': translate(translation_map, parsed.port),
        'schema': translate(translation_map, schema),
    }
    
    result_json = json.dumps(result)
    print(result_json)
