#!/bin/bash

source ~/.bash_profile
shopt -s expand_aliases

psql -h localhost -p 5432 -U postgres billing_system -f create_db.sql
psql -h localhost -p 5432 -U postgres billing_system -f create_fnc.sql
psql -h localhost -p 5432 -U postgres billing_system -f fill_db.sql
