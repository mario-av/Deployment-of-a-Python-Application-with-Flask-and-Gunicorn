# Vagrantfile - Python Flask & Gunicorn & Nginx
# Date: January 2026

Vagrant.configure("2") do |config|

  # 1. Base OS Image
  config.vm.box = "debian/bullseye64"

  # 2. Hostname
  config.vm.hostname = "flask.local"

  # 3. Private Network
  config.vm.network "private_network", ip: "192.168.56.120"

  # 4. Port Forwarding
  # Forward Guest 80 (Nginx) to Host 8080
  config.vm.network "forwarded_port", guest: 80, host: 8080
  # Forward Guest 5000 (Gunicorn/Flask Dev) to Host 5000
  config.vm.network "forwarded_port", guest: 5000, host: 5000

  # 5. VirtualBox Provider Settings
  config.vm.provider "virtualbox" do |vb|
    vb.name = "Python-Flask-Server"
    vb.memory = "2048"
    vb.cpus = 2
  end

  # 6. Synced Folder
  config.vm.synced_folder "config", "/vagrant/config"

  # 7. Provisioning Script
  config.vm.provision "shell", path: "config/bootstrap.sh"

  # 8. End of Configuration
end
