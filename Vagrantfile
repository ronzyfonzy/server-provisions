$script = <<SCRIPT
sudo apt-get -qq -y -f install git
sudo mkdir -p /home/vagrant/provision
sudo git clone https://github.com/ronzyfonzy/server-provisions.git /home/vagrant/provision
pushd .
cd /home/vagrant/provision
sudo git checkout develop
sudo chmod +x provisions/default.sh
sudo ./provisions/default.sh -i
popd
SCRIPT

Vagrant.configure(2) do |config|

	config.vm.box = "ubuntu/trusty64"

	config.vm.provider "virtualbox" do |v|
		v.memory = 1024
	end

	forward_port = ->(guest, host = guest) do
		config.vm.network :forwarded_port,
		guest: guest,
		host: host,
		auto_correct: true
	end

	forward_port[9000, 9000]  # nodejs
	forward_port[80, 8080]    # http
	forward_port[90, 8090]    # adminer

	config.vm.provision "shell", inline: $script

end
