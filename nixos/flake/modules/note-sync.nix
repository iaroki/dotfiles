{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.note-sync.packages."x86_64-linux".note-sync
  ];
}
