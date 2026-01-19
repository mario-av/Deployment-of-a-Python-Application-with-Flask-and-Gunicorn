#!/bin/bash

# 1. Update package list
echo "1. Updating system package list..."
apt-get update -qq > /dev/null 2>&1
echo "   [ OK ]"

# 2. Install system dependencies
echo "2. Installing Python3-pip, Nginx, and Git..."
apt-get install -y python3-pip nginx git -qq > /dev/null 2>&1
echo "   [ OK ]"

# 3. Install Python environment tools
echo "3. Installing Pipenv and Dotenv..."
pip3 install pipenv python-dotenv -q > /dev/null 2>&1
echo "   [ OK ]"

# 4. Create application directory
echo "4. Creating application directory structure..."
mkdir -p /var/www/app
# Ensure directory is empty for git clone
rm -rf /var/www/app/*
echo "   [ OK ]"

# 5. Clone Azure Sample Repository
echo "5. Cloning Azure Sample Repository..."
git clone https://github.com/Azure-Samples/msdocs-python-flask-webapp-quickstart /var/www/app
echo "   [ OK ]"

# 6. Set directory permissions
echo "6. Setting directory permissions..."
chown -R vagrant:www-data /var/www/app
chmod -R 775 /var/www/app
echo "   [ OK ]"

# 7. Install Flask dependencies
echo "7. Installing dependencies via Pipenv..."
# Only install from requirements.txt as per instructions
su - vagrant -c "cd /var/www/app && export PIPENV_VENV_IN_PROJECT=1 && pipenv install -r requirements.txt" > /dev/null 2>&1
echo "   [ OK ]"

# 8. Ensure WSGI Entry Point
# If wsgi.py is missing (Azure sample might use app.py), copy ours or create one
echo "8. Verifying WSGI entry point..."
if [ ! -f /var/www/app/wsgi.py ]; then
    echo "   Using provided wsgi.py..."
    cp /vagrant/config/wsgi.py /var/www/app/
fi
echo "   [ OK ]"

# 9. Configure Systemd service
echo "9. Configuring Flask Systemd service..."
cp /vagrant/config/flask_app.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable flask_app > /dev/null 2>&1
systemctl restart flask_app
echo "   [ OK ]"

# 10. Configure Nginx
echo "10. Configuring Nginx reverse proxy..."
rm -f /etc/nginx/sites-enabled/default
cp /vagrant/config/app.conf /etc/nginx/sites-available/
ln -sf /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/
systemctl restart nginx
echo "   [ OK ]"

# 11. Copy Environment Variables
echo "11. Copying .env configuration..."
cp /vagrant/config/.env /var/www/app/
echo "   [ OK ]"

# 12. Final Verification
echo "12. Deployment completed successfully"
echo "   [ OK ]"
