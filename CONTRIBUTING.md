Hello! Some familiarity with Git is assumed, so instead this will be about using Nix to run a virtual machine off this repository. This is very useful when testing changes, as the packages don't apply to your host system, so you can easily bail if something broke.

A NixOS host is not required to contribute. Arch Linux instructions are also available, albeit with a large download as Nix will get its own packages instead of using `pacman`.

## Requirements
* Nix package manager or NixOS
* Up to ~4GB download and ~12GB of storage space at worst
* 4 CPU cores and 4096MB RAM for the VM, which [can be edited](vms/aerothemeplasma.nix)
* [Font files](README.md#fonts) from an [up-to-date](https://github.com/nyakase/aerothemeplasma-nix/issues/15#issuecomment-3941785456) Windows® 7 install if testing Plymouth
* x86-64 host capable of [mesa hardware acceleration](https://docs.mesa3d.org/faq.html#rendering-is-slow-why-isn-t-my-graphics-hardware-being-used)
* virt-viewer as the [SPICE](https://spice-space.org) client

### Arch Linux host
Install the required packages: `sudo pacman -S --needed nix virt-viewer`

Installing Nix creates a `/nix` folder, which is managed by the Nix daemon. Enable its service with `sudo systemctl enable --now nix-daemon`. Then, for [convenience](https://discourse.nixos.org/t/error-experimental-nix-feature-nix-command-is-disabled/18089), create `~/.config/nix/nix.conf` to enable a couple "experimental features" like so:
```
extra-experimental-features = nix-command flakes
```

### NixOS host
Your NixOS configuration should have these options:
```nix
{pkgs, ...}:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [ virt-viewer ];
}
```

## Build and run
The command to run the VM differs depending on the host distro. Run one of these in the project folder:
```
# on NixOS
nix run .#nixosConfigurations.atp.config.system.build.vm
# not on NixOS
nix run --impure github:nix-community/nixGL -- nix run .#nixosConfigurations.atp.config.system.build.vm
```

Nix will prepare some packages in `/nix/store`, so your first time will take a while. Future builds will reuse the existing packages, and editing packages will rebuild only them and their dependents. When the VM is ready, virt-viewer will automatically open (the password is `anon`).

To test new changes, just close the VM and run it again. To delete the user files in the VM, e.g. if re-testing AeroThemePlasma's setup wizard, delete the `nixos.qcow2` disk image in the project folder.

Once you are finished and want to delete the prepared packages you can use `nix store gc -v`, which keeps `/nix/store` assets used in places like your own NixOS system, but gets rid of the rest.