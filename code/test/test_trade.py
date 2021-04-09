import unittest

import sys
import os, json, logging
codepath = os.path.join(os.getcwd(),"code")
sys.path.append(codepath)
from trade import share
print(codepath)

class Test(unittest.TestCase):

    def test_share(self):
        tb =  share(code='600111.SH',begin="2021-01-01", end = "2021-03-01" )
        logging.info("result：\n%s",share.cdata)

    

        
if __name__ == "__main__":
    unittest.main()