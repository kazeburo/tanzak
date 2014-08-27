Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.network "forwarded_port", guest:15000, host:15000
  config.vm.provision "docker", run: "always" do |d|
    d.pull_images "kazeburo/perl:v5.20"
  end
end
