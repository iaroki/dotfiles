{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 7777 ]; # web expose
  networking.firewall.allowedTCPPorts = [ 60000 60001 ]; # mosh-server

  services.openssh = {
    enable = true;
    ports = [ 1337 ];
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
