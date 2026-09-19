# This file defines your secrets and their access rules
# Each secret should specify which public keys can decrypt it

let
  # Host keys are the SSH host key converted to age. On the host:
  #   nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'
  homelab-0-k3s-0 = "age1jusjv76tclv5kmy38rcnjtpuant4nsas3lkagxq8arr8fy440qqsanps67";
  homelab-0-k3s-1 = "age1x9a32tal7zhe4mn2lu5xd24rwj4md6cl2r4avgtw6zf3jseq7dlsz6dmm2";
  homelab-0-devbox = "age1newvjan5yx5y7np4ww8wtq95xa320qtrvu87uvul0lz5y05lmaqqn9u9mv";
  homelab-0-home-assistant = "age15s0rzpuay6hc05feudk4vn8jglqudskzsmvh7xwgh689yy5n298q3dumlx";
  homelab-0-ollama = "age1e2ae8ejdev7e8g6p8g05k7uvteadtf2kksn58hh90jf779nfc5gsq0njj5";

  backup = "age1vytxt7vz68rad8ua007zpj5n28329206lq34rzsgnvswuufh7fhq8k0mdp"; # Backup age public key

  # Each host reads only the secrets it needs; there is no shared "all hosts"
  # list, so a compromised host does not expose another host's credentials.
  k3s = [ homelab-0-k3s-0 homelab-0-k3s-1 backup ];
  devbox = [ homelab-0-devbox backup ];
  home-assistant = [ homelab-0-home-assistant backup ];
  ollama = [ homelab-0-ollama backup ];
in
{
  "secrets/k3s/token.age".publicKeys = k3s;

  "secrets/devbox/tailscale-authkey.age".publicKeys = devbox;
  "secrets/devbox/git-key.age".publicKeys = devbox;
  "secrets/devbox/gh-token.age".publicKeys = devbox;

  "secrets/home-assistant/tailscale-authkey.age".publicKeys = home-assistant;
  "secrets/ollama/tailscale-authkey.age".publicKeys = ollama;
}
