#!/bin/sh

cmd='/usr/local/mysql/bin/mysql deanery --user=root --password='andyandy''

$cmd < create_db.sql
$cmd < fill_db.sql 

$cmd -e "select last_name from students natural join persons order by birth_date;"