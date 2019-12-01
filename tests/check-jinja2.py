#!/usr/bin/python3
#Description: check jinja2 syntax
# Source: https://stackoverflow.com/questions/37939131/how-to-validate-jinja-syntax-without-variable-interpolation#37939821
import sys
from jinja2 import Environment

env = Environment()
with open(sys.argv[1]) as template:
    env.parse(template.read())

