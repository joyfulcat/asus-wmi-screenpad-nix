An adaptation of the asus-wmi-screenpad kernel module to a nix derivation. This is not a fully contained module, and not meeting the nix standard entirely as it is not gonna run sandboxed and without prefetching the needed resources in `prepare-for-current-kernel.sh`, subsequently having to be run with `--option sandbox false`.


### Steps to run:

1. Clone the repository or copy `asus-wmi-screenpad.nix` directly and save it in `/etc/nixos/`

2. Include the kernel module (depending on the name) inside your `configuration.nix` file

3. Prefetch the needed patch depending on kernel from `prepare-for-current-kernel.sh` using `curl`

4. Run `sudo nixos-rebuild switch --option sandbox false`


If you encounter any problems, feel free to open an issue, as this is by no means a production level module. Also, feel free to contribute in order to make this up to the nix standard in its entirety.
