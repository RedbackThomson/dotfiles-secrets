# Dotfiles Secrets

Encrypted secrets for RedbackThomson's dotfiles using ragenix (age-based encryption).

## Setup

1. **Generate an age key** (if you don't have one):
   ```bash
   # Using ssh-to-age (recommended if you have SSH keys)
   nix shell nixpkgs#ssh-to-age -c sh -c 'echo "ssh-ed25519 AAAA..." | ssh-to-age'

   # Or generate a new age key
   nix shell nixpkgs#age -c age-keygen -o ~/.config/age/key.txt
   ```

2. **Update secrets.nix** with your age public key(s)

3. **Enter the development shell**:
   ```bash
   nix develop
   ```

## Usage

### Creating/Editing Secrets

```bash
# Edit a secret (creates if doesn't exist)
ragenix edit secrets/my-secret.age

# Re-key all secrets (after updating secrets.nix)
ragenix rekey
```

### Using Secrets in NixOS

In your NixOS configuration:

```nix
{
  imports = [
    inputs.dotfiles-secrets.nixosModules.default
  ];

  age.secrets.my-secret = {
    file = inputs.dotfiles-secrets + "/secrets/my-secret.age";
    mode = "0440";
    owner = "root";
    group = "users";
  };

  # Use the secret path: config.age.secrets.my-secret.path
}
```

### Using Secrets in Home Manager

In your home-manager configuration:

```nix
{
  imports = [
    inputs.dotfiles-secrets.homeManagerModules.default
  ];

  age.secrets.my-secret = {
    file = inputs.dotfiles-secrets + "/secrets/my-secret.age";
  };

  # Use the secret path: config.age.secrets.my-secret.path
}
```

## File Structure

```
.
├── flake.nix          # Main flake configuration
├── secrets.nix        # Defines which keys can decrypt which secrets
├── secrets/           # Encrypted secrets directory
│   └── *.age         # Encrypted secret files (commit these)
└── README.md         # This file
```

## Security Notes

- Never commit unencrypted secrets to git
- Only `.age` files should be committed
- Keep your age private key (`~/.config/age/key.txt`) secure and backed up
- For NixOS systems, consider using the host SSH key for decryption
