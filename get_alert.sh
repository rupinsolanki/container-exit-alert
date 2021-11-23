#!/bin/bash       
              
SUBJECT="ALERT: Your container is down"
EMAIL_FROM=""
EMAIL_TO=""
FROM_NAME=""


list_of_containers="container1 container2 container3"
livecontainers=`docker ps -f status=running --format {{.Names}}`
for container in list_of_containers
do
  if echo $livecontainers | grep -q $container
  then 
    echo "$container is running"
  else
  msg=$(echo "$container is down")
  bodyHTML="<p> $msg </p>"
  mail='{"personalizations": [{ "to": [{ "email": "'"$EMAIL_TO"'"}], "subject": "'"$SUBJECT"'"}],"from":{ "email": "'"$EMAIL_FROM "'", "name": "'"$FROM_NAME"'"},"content": [{ "type": "text/plain", "value": "'"$bodyHTML"'"}] }';
  curl -X "POST" "https://api.sendgrid.com/v3/mail/send" \
      -H "Authorization: Bearer "SENDGRID_API_KEY" \
      -H "Content-Type: application/json" \
      -d  "$mail"
  fi
done
exit 0 

