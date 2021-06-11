#!/bin/bash

echo "DB_TYPE	: $DB_TYPE"
echo "DB_HOST	: $DB_HOST"
echo "DB_PORT	: $DB_PORT"
echo "DB_NAME	: $DB_NAME"
echo "DB_USER	: $DB_USER"

CHANGELOG_TABLE="CHANGELOG"
if [[ ! -z "$DB_TYPE" ]] ; then
    CHANGELOG_TABLE="CHANGELOG_$DB_TYPE"

    echo "DB_TYPE			: $DB_TYPE"
    echo "CHANGELOG_TABLE	: $CHANGELOG_TABLE"
fi

if [ "$DB_TYPE" == "Oracle" ] ; then
	echo "> Oracle Database"
	
	DB_DRIVER="oracle.jdbc.driver.OracleDriver"
	DB_CONNECTION_URL="jdbc:oracle:thin:@$DB_HOST:$DB_PORT:$DB_NAME"
	DB_JAR="ojdbc8-12.2.0.1.jar"
fi

if [ "$DB_TYPE" == "DB2" ] ; then
	echo "> DB2 Database"
	
	DB_DRIVER="com.ibm.db2.jcc.DB2Driver"
	DB_CONNECTION_URL="jdbc:db2://$DB_HOST:$DB_PORT/$DB_NAME"	
	DB_JAR="db2jcc4-10.1.jar"
fi

if [ "$DB_TYPE" == "SQL" ] ; then
	echo "> SQL Database"
	
	DB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
	DB_CONNECTION_URL="jdbc:sqlserver://$DB_HOST:$DB_PORT;DatabaseName=$DB_NAME"
	DB_JAR="sqljdbc4-4.0.jar"
fi

echo "DB_DRIVER			: $DB_DRIVER"
echo "DB_CONNECTION_URL	: $DB_CONNECTION_URL"


#Create Mybatis folder Structure
#------------------------------------
mkdir -p migration/drivers
mkdir -p migration/environments
mkdir -p migration/scripts

#Create development.properties 
#-----------------------------------------------------------
cat <<CONF > migration/environments/development.properties

time_zone=CET
driver=$DB_DRIVER
url=$DB_CONNECTION_URL
username=$DB_USER
password=$DB_PASSWORD

script_char_set=UTF-8
send_full_script=false
delimiter=;
full_line_delimiter=false

auto_commit=false
changelog=$CHANGELOG_TABLE
ignore_warnings=true

CONF

#copy jars
#------------
cp -R $WORKSPACE/mybatis-automations/$DB_JAR migration/drivers

#copy changlog scripts
#----------------------

cp -R $WORKSPACE/mybatis-automations/20210608052232_create_changelog.sql migration/scripts/20210608052232_create_changelog_$DB_TYPE.sql
