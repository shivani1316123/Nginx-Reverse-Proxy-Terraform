#!/bin/bash

# Update the system
apt update -y

# Install required packages
apt install -y nginx python3 unzip wget

# Create website directories
mkdir -p /var/www/html/burger
mkdir -p /var/www/html/travel
mkdir -p /var/www/html/shopping

# Download website ZIP files
wget -O /tmp/burger.zip https://your-bucket.s3.amazonaws.com/burger.zip
wget -O /tmp/travel.zip https://your-bucket.s3.amazonaws.com/travel.zip
wget -O /tmp/shopping.zip https://your-bucket.s3.amazonaws.com/shopping.zip

# Extract the websites
unzip -o /tmp/burger.zip -d /var/www/html/burger
unzip -o /tmp/travel.zip -d /var/www/html/travel
unzip -o /tmp/shopping.zip -d /var/www/html/shopping

# Start Python web servers
cd /var/www/html/burger
nohup python3 -m http.server 8081 > /tmp/burger.log 2>&1 &

cd /var/www/html/travel
nohup python3 -m http.server 8082 > /tmp/travel.log 2>&1 &

cd /var/www/html/shopping
nohup python3 -m http.server 8083 > /tmp/shopping.log 2>&1 &

#----------------------------------------
# Configure Nginx Reverse Proxy
#----------------------------------------

mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

cat <<EOF > /etc/nginx/sites-available/reverseproxy

server {

    listen 80;
    server_name _;

    location / {

        default_type text/html;

        return 200 '
<!DOCTYPE html>
<html>
<head>
<title>Terraform Reverse Proxy</title>
<style>
body{
font-family:Arial;
background:#f5f5f5;
text-align:center;
padding-top:80px;
}
a{
display:block;
font-size:22px;
margin:20px;
text-decoration:none;
color:#0066cc;
}
</style>
</head>

<body>

<h1>AWS Infrastructure Automation using Terraform</h1>

<h2>Nginx Reverse Proxy Project</h2>

<hr>

<a href="/burger/">🍔 Burger Website</a>

<a href="/travel/">✈️ Travel Website</a>

<a href="/shopping/">🛒 Shopping Website</a>

</body>
</html>';

    }

    location /burger/ {

        proxy_pass http://127.0.0.1:8081/;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    }

    location /travel/ {

        proxy_pass http://127.0.0.1:8082/;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    }

    location /shopping/ {

        proxy_pass http://127.0.0.1:8083/;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

    }

}

EOF

#----------------------------------------
# Enable Reverse Proxy Site
#----------------------------------------

ln -sf /etc/nginx/sites-available/reverseproxy /etc/nginx/sites-enabled/reverseproxy

rm -f /etc/nginx/sites-enabled/default

#----------------------------------------
# Test Nginx Configuration
#----------------------------------------

nginx -t

#----------------------------------------
# Restart Nginx
#----------------------------------------

systemctl restart nginx
systemctl enable nginx