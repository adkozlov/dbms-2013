#!/bin/bash

source ~/.bash_profile
shopt -s expand_aliases

psql billing_system -f create_db.sql
psql billing_system -f create_fnc.sql
psql billing_system -f fill_db.sql
