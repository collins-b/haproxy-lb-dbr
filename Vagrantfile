Vagrant.configure("2") do |config|
    config.vm.define "haproxyserver" do |haproxyserver|
      haproxyserver.vm.box = "ubuntu/trusty64"
      haproxyserver.vm.hostname = 'haproxyserver'
      haproxyserver.vm.network :private_network, ip: "192.168.56.100"
      haproxyserver.vm.network :forwarded_port, guest: 22, host: 10122, id: "ssh"
      haproxyserver.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--name", "haproxyserver"]
      end
    end
    config.vm.define "master" do |master|
      master.vm.box = "ubuntu/trusty64"
      master.vm.hostname = 'master'
      master.vm.network :private_network, ip: "192.168.56.101"
      master.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
      master.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--name", "master"]
      end
    end
    config.vm.define "slave1" do |slave1|
        slave1.vm.box = "ubuntu/trusty64"
        slave1.vm.hostname = 'slave1'
        slave1.vm.network :private_network, ip: "192.168.56.102"
        slave1.vm.network :forwarded_port, guest: 22, host: 10322, id: "ssh"
        slave1.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--memory", 2048]
          v.customize ["modifyvm", :id, "--name", "slave1"]
        end
      end
      config.vm.define "slave2" do |slave2|
        slave2.vm.box = "ubuntu/trusty64"
        slave2.vm.hostname = 'slave2'
        slave2.vm.network :private_network, ip: "192.168.56.103"
        slave2.vm.network :forwarded_port, guest: 22, host: 10422, id: "ssh"
        slave2.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
          v.customize ["modifyvm", :id, "--memory", 2048]
          v.customize ["modifyvm", :id, "--name", "slave2"]
        end
      end
  end
