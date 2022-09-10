{ pkgs, attrs, ... }:

{
  home.packages = [
    attrs.note-sync.packages."${system}".note-sync
  ];
}
