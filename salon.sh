#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
# PSQL="psql --username=freecodecamp --dbname=salon -c"
VAR=$($PSQL "")

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
	if [[ $1 ]]; then
		echo -e "\n$1"
	fi

	# echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
	SERVICES=$($PSQL "select service_id,name from services order by service_id;")
	echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME; do
		echo "$SERVICE_ID) $SERVICE_NAME"
	done

	read SERVICE_ID_SELECTED
	if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
		# send to main menu
		MAIN_MENU "I could not find that service. What would you like today?"
	fi

	CHECK_SERVICE=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
	if [[ -z $CHECK_SERVICE ]]; then
		MAIN_MENU "I could not find that service. What would you like today?"
	fi

	SERVICE_NAME_SELECTED=$CHECK_SERVICE

	BEGIN_BOOKING "$SERVICE_ID_SELECTED" "$SERVICE_NAME_SELECTED"
}

BEGIN_BOOKING() {
	echo -e "\nWhat's your phone number?"

	read CUSTOMER_PHONE
	CHECK_PHONE_RESULT=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
	if [[ -z $CHECK_PHONE_RESULT ]]; then
		echo -e "\nI don't have a record for that phone number, what's your name?"
		read CUSTOMER_NAME
		INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
		CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
		CUSTOMER_ID=$(echo "$CUSTOMER_ID" | sed -E 's/^ *| *$//')
	else
		CUSTOMER_ID=$(echo "$CHECK_PHONE_RESULT" | sed -E 's/^ *| *$//')
		CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
		CUSTOMER_NAME=$(echo "$CUSTOMER_NAME" | sed -E 's/^ *| *$//')
	fi

	SERVICE_NAME_FORMATTED=$(echo $2 | sed -E 's/^ *| *$//')
	echo -e "\nWhat time would you like your $SERVICE_NAME_FORMATTED, $CUSTOMER_NAME?"
	read SERVICE_TIME

	APPOINTMENT_RESULT=$($PSQL "insert into appointments (customer_id,service_id,time) values($CUSTOMER_ID,$1,'$SERVICE_TIME')")
	echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
