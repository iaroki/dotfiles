{
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 7777 ]; # web expose
  networking.firewall.allowedUDPPorts = [ 60000 60009 ]; # mosh-server

  services.openssh = {
    enable = true;
    ports = [ 1337 ];
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
