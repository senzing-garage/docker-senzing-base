#! /usr/bin/env python

import os
import json
from urlparse import urlparse

senzing_database_url = os.environ.get('SENZING_DATABASE_URL')
parsed = urlparse(senzing_database_url)
schema = parsed.path.strip('/')

result = {
    'scheme': parsed.scheme,
    'netloc': parsed.netloc,
    'path': parsed.path,
    'params': parsed.params,
    'query': parsed.query,
    'fragment': parsed.fragment,
    'username': parsed.username,
    'password': parsed.password,
    'hostname': parsed.hostname,
    'port': parsed.port,
    'schema': schema,
}

result_json = json.dumps(result)
print(result_json)
