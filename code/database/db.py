#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os                                                             
import sqlite3
from config import dataPath as root
sqlpath = os.path.join(root, "stockdate/sql/")
con = sqlite3.connect(sqlpath+'sqlite.db')
