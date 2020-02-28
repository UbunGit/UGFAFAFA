import logging
import time
import sys

# logging.basicConfig(format='%(asctime)s %(message)s ', filename='sequoia.log')

logging.basicConfig(format='%(asctime)s %(message)s ')
logging.getLogger().setLevel(logging.DEBUG)

logging.debug(sys.version)