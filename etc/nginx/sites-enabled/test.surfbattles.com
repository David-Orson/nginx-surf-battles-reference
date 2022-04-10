server {
#    if ($host = test.surfbattles.com) {
 #       return 301 https://$host$request_uri;
  #  } # managed by Certbot


   listen 80;
   listen [::]:80;
   server_name test.surfbattles.com surfbattles.com www.surfbattles.com;
   return 301 https://test.surfbattles.com$request_uri;
}

server {
    listen 443 ssl;
    listen [::]:443 ssl ipv6only=on;
    server_name test.surfbattles.com surfbattles.com www.surfbattles.com;
    ssl_certificate /etc/letsencrypt/live/test.surfbattles.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/test.surfbattles.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

        if ($host = surfbattles.com) {
                return 301 https://test.surfbattles.com$request_uri;
        }

        if ($host = www.surfbattles.com) {
                return 301 https//test.surfbattles.com$request_uri;
        }

    location /api/ {
        proxy_pass http://localhost:8085;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location / {
        root /var/www/test.example.com;
    }
}
