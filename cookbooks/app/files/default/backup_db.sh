#!/bin/bash

mysqldump -A | gzip -c > all_db.sql.gz
mysqldump SliderAppDB | gzip -c > SliderAppDB.sql.gz
mysqldump DigitalCandy | gzip -c > DigitalCandy.sql.gz
mysqldump DigitalCandy_test | gzip -c > DigitalCandy_test.sql.gz

for i in `seq 7001 7032`; do
	gzip -c /var/lib/redis/dump-$i.rdb > redis-$i.rdb.gz
done

