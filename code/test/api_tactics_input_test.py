import unittest
import logging
import tushare as ts
import requests as requests

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别


BaseUrl = "http://localhost:5000"

class Test(unittest.TestCase):
    @unittest.skip("跳过该测试项")    
    def test_add(self):
  
        url = BaseUrl+'/tacticsinput/add'
        response = requests.post(url=url,data={"owner":"","name":"test"})
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")
   
    def test_list(self):
  
        url = BaseUrl+'/tacticsinput/list'
        response = requests.get(url=url,params={"id":1})
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

    @unittest.skip("跳过该测试项")  
    def test_update(self):
  
        url = BaseUrl+'/tacticsinput/update'
        response = requests.post(url=url,data={"id":1,"doc":"111"})
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

    @unittest.skip("跳过该测试项")   
    def test_detailed(self):
  
        url = BaseUrl+'/tacticsinput/detailed'
        response = requests.get(url=url,params={"id":1})
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

if __name__ == "__main__":
    unittest.main()

