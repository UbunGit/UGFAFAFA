#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def valueof(parameter,key):
    for item in parameter:
        if item["key"] == key:
            return item["value"]