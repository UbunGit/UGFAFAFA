#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sqlite3

def trade_create(path):
    conn = sqlite3.connect(path)
    c = conn.cursor()

    create = '''
        CREATE TABLE IF NOT EXISTS trade(
        id INTEGER PRIMARY KEY   AUTOINCREMENT,
        name TEXT NOT NULL,
        path TEXT NOT NULL
        );
        '''

    c.execute(create)
    print ("sqlite: trade created successfully")
    conn.commit()
    conn.close()

def trade_inster(path, name, tpath):
    conn = sqlite3.connect(path)
    c = conn.cursor()
    sql = '''
        INSERT INTO trade (name,path) VALUES ('{0}' ,'{1}');
        '''.format(name,tpath)
    print(sql)
    c.execute(sql)
    print ("sqlite: trade inster successfully")
    conn.commit()
    conn.close()


# ######################################
import unittest
from config import path
class setup(unittest.TestCase):

    def test_trade_inster(self):
        trade_inster(path,"macd","/001")
        self.assertEqual(True, True)


if __name__ == '__main__':
    unittest.main()



