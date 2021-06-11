#!/bin/bash

echo "-- //$FILE_NAME" > migrate-script

cat $FILE_NAME >> migrate-script

echo "-- //@UNDO" >> migrate-script

if [[ ! -z "$UNDO_FILE_NAME" ]] ; then
    cat $UNDO_FILE_NAME >> migrate-script
fi

mv migrate-script $WORKSPACE/migration/scripts/`date +%Y%m%d%H%M%S`_$FILE_NAME.sql
