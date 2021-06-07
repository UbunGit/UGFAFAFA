#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def valueof(params,key):
    for item in params:
        if item["key"] == key:
            return item["value"]