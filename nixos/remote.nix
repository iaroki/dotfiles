{
  services.openssh = {
    enable = true;
    ports = [ 1337 ];
    passwordAuthentication = false;
    permitRootLogin = "no";
  };
}
