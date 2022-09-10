{ pkgs, attrs, ... }:

{
  home.packages = [
    attrs.note-sync.packages."x86_64-linux".note-sync
  ];
}
