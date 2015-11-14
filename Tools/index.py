#!/usr/bin/env python

import sys
import yaml

try:
    draft = yaml.load_all(open(sys.argv[1]).read())
except:
    sys.exit(0)
for section in draft:
    print '- ' + section['title']
    break
