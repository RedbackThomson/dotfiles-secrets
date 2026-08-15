# This file defines your secrets and their access rules
# Each secret should specify which public keys can decrypt it

let
  # Host keys are the SSH host key converted to age. On the host:
  #   nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'
  homelab-0-k3s-0 = "age1jusjv76tclv5kmy38rcnjtpuant4nsas3lkagxq8arr8fy440qqsanps67";
  homelab-0-devbox = "age1newvjan5yx5y7np4ww8wtq95xa320qtrvu87uvul0lz5y05lmaqqn9u9mv";

  backup = "age1mw2vmtqsaq8mnmgv4lzcl9f2hmmsluj9ks56rtvqvujrlssqjussng7a4f"; # Backup age public key

  # Each host reads only the secrets it needs; there is no shared "all hosts"
  # list, so a compromised host does not expose another host's credentials.
  k3s = [ homelab-0-k3s-0 backup ];
  devbox = [ homelab-0-devbox backup ];
in
{
  "secrets/k3s/token.age".publicKeys = k3s;

  "secrets/devbox/tailscale-authkey.age".publicKeys = devbox;
  "secrets/devbox/git-key.age".publicKeys = devbox;
  "secrets/devbox/gh-token.age".publicKeys = devbox;
}
