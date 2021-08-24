#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import db import con

def istable(name):
    cur = con.cursor()
    con.close()