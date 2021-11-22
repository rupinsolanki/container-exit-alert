#!/bin/bash       
              
SUBJECT=""
EMAIL_FROM=""
EMAIL_TO=""
FROM_NAME=""


container="container name"
checkStatus=$(docker inspect -f {{.State.Running}} "$container")
if [ "$checkStatus" == true ]
then 
  echo "$container is running"
else
msg=$(echo "Container is down")
bodyHTML="<p> $msg </p>"
mail='{"personalizations": [{ "to": [{ "email": "'"$EMAIL_TO"'"}], "subject": "'"$SUBJECT"'"}],"from":{ "email": "'"$EMAIL_FROM "'", "name": "'"$FROM_NAME"'"},"content": [{ "type": "text/plain", "value": "'"$bodyHTML"'"}] }';
curl -X "POST" "https://api.sendgrid.com/v3/mail/send" \
    -H "Authorization: Bearer "SENDGRID_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$mail"
fi 
