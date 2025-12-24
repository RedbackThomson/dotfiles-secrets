# This file defines your secrets and their access rules
# Each secret should specify which public keys can decrypt it

let
  # Define your public keys here
  # Generate with: ssh-keyscan github.com | ssh-keygen -lf -
  # Or from existing key: ssh-keygen -y -f ~/.ssh/id_ed25519 | ssh-to-age

  # Example user keys (replace with your actual age public keys)
  user1 = "age1mw2vmtqsaq8mnmgv4lzcl9f2hmmsluj9ks56rtvqvujrlssqjussng7a4f"; # Your age public key

  # Example system keys (for NixOS hosts)
  system1 = "age1..."; # Host system's age public key

  # Group keys by role
  users = [ user1 ];
  systems = [ system1 ];
  allKeys = users ++ systems;
in
{
  # Example secret definitions
  # "secrets/example-secret.age".publicKeys = allKeys;
  # "secrets/api-token.age".publicKeys = users;
  # "secrets/system-password.age".publicKeys = systems;
  "secrets/k3s/token.age".publicKeys = users;
}
