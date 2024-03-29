import unittest
import logging
import tushare as ts
import requests as requests

logging.basicConfig(level=logging.NOTSET)  # 设置日志级别


BaseUrl = "http://localhost:5000"

class Test(unittest.TestCase):
    
    @unittest.skip("跳过该测试项：test_test") 
    def test_test(self):
        
        url = BaseUrl+'/share/test'
        response = requests.get(url=url)
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

    @unittest.skip("跳过该测试项：test_sharehistory")    
    def test_sharehistory(self):

        arg={
        "code":"000100",
        "begin":"2020-07-10",
        }
        url = BaseUrl+'/sharehistory'
        response = requests.get(url=url,parameter= arg)
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

    
    def test_addcategory(self):
        
        url = BaseUrl+'/sharelike/addcategory'
        response = requests.post(url=url,data={"name":"test"})
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

    def test_listcategory(self):
        
        url = BaseUrl+'/sharelike/listcategory'
        response = requests.get(url=url)
        logging.info("-------------begin--------------")
        logging.info(response.status_code)
        logging.info(response.url)
        logging.info(response.content)
        logging.info("----------------end-------------")

        



        
if __name__ == "__main__":
    unittest.main()

