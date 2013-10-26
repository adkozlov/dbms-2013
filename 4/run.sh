#!/bin/sh

cmd='/usr/local/mysql/bin/mysql deanery --user=root --password='andy''

$cmd < create_db.sql
$cmd < fill_db.sql

$cmd -e 'select student_name, course_name, points from marks natural join courses natural join students;'