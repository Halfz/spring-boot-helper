#/bin/bash

if [ "$#" -eq 1 ]
then
   echo "create ssl certification for domain: $1"
else
   echo "Usage: ./cert.sh <domain>"
   exit 1
fi
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
sudo mkdir /home/www
sudo mkdir /home/www/.well-known
sudo chown -R nginx:nginx /home/www
sudo chmod 755 /home/www
cat <<EOF >> /etc/nginx/conf.d/certbot.conf
server {
      listen 80 default_server;
      location /.well-known {
         allow all;
         alias /home/www/.well-known/;
         try_files $uri /dev/null =404;
      }
}
EOF
./apps/certbot-auto certonly --webroot -w /home/www -d $1
CMD="0 6 * * * /home/halfz/apps/certbot-auto renew --text >> /home/halfz/logs/certbot-cron.log && sudo service nginx reload"
(crontab -l ; echo "$CMD") 2>&1 | grep -v "no crontab" | grep -v "$CMD" |  sort | uniq | crontab -

cat <<EOF >> /etc/nginx/conf.d/$1.conf

  server {
    listen       443 ssl;
    server_name  $1;
    ssl_certificate /etc/letsencrypt/live/$1/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$1/privkey.pem;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
    access_log   /var/log/$1.log  main;

    # allow large uploads of files
    client_max_body_size 1G;
    location / {
      proxy_pass      http://127.0.0.1:8080;
      proxy_http_version 1.1;
      proxy_set_header Connection "";
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto "https";
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "Upgrade";
      proxy_connect_timeout 600;
      proxy_send_timeout 600;
      proxy_read_timeout 600;
      send_timeout 600;
    }
}
EOF
sudo service nginx restart
