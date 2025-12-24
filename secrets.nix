# This file defines your secrets and their access rules
# Each secret should specify which public keys can decrypt it

let
  # Define your public keys here
  # Generate with: ssh-keyscan github.com | ssh-keygen -lf -
  # Or from existing key: ssh-keygen -y -f ~/.ssh/id_ed25519 | ssh-to-age

  # Example system keys (for NixOS hosts)
  homelab-0-k3s-0 = "age1jusjv76tclv5kmy38rcnjtpuant4nsas3lkagxq8arr8fy440qqsanps67";

  backup = "age1mw2vmtqsaq8mnmgv4lzcl9f2hmmsluj9ks56rtvqvujrlssqjussng7a4f"; # Backup age public key

  # Group keys by role
  users = [  ];
  systems = [ homelab-0-k3s-0 ];
  allKeys = users ++ systems ++ [ backup ];
in
{
  "secrets/k3s/token.age".publicKeys = allKeys;
}
