#!/bin/bash

if [[ ! -z "$FILE_NAME" ]] ; then
    echo "-- //$FILE_NAME" > migrate-script
    sed -i "s/$SCHEMA_NAME.//g" mybatis-scripts/$FILE_NAME
    cat mybatis-scripts/$FILE_NAME >> migrate-script
fi

if [[ ! -z "$UNDO_FILE_NAME" ]] ; then
    echo "-- //@UNDO" >> migrate-script
    sed -i "s/$SCHEMA_NAME.//g" $UNDO_FILE_NAME
    cat mybatis-scripts/$UNDO_FILE_NAME >> migrate-script
fi

if [[ ! -z "$FILE_NAME" ]] ; then
    
    mv migrate-script $WORKSPACE/migration/scripts/`date +%Y%m%d%H%M%S`_$FILE_NAME.sql

fi
