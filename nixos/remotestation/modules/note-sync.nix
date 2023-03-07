{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.note-sync.packages."x86_64-linux".note-sync
  ];

  home.file.note-sync-config = {
    executable = true;
    target = ".config/note-sync/config.yaml";
    text = ''
      notes_dir: zettelkasten
      encrypted_dir: vault
      git_dir:  /home/msytnyk/dev/personal/notes
      gpg_public_key: /home/msytnyk/.gnupg/public.gpg
      gpg_private_key: /home/msytnyk/.gnupg/private.gpg
      ssh_private_key: /home/msytnyk/.ssh/id_rsa
    '';
  };
}
