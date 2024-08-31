An adaptation of the [asus-wmi-screenpad](https://github.com/Plippo/asus-wmi-screenpad) kernel module to a nix derivation. This is not a fully contained module, and not meeting the nix standard entirely as it is not gonna run sandboxed and without prefetching the needed resources in `prepare-for-current-kernel.sh`, subsequently having to be run with `--option sandbox false`.

Before trying to run this, it's worth taking a look at the [original documentaion](https://github.com/Plippo/asus-wmi-screenpad/blob/master/README.md) to understand better how the module works.

### Steps to run:

1. Clone the repository or copy `asus-wmi-screenpad.nix` directly and save it in `/etc/nixos/`

2. Make the following changes in `configuration.nix`:

```
#the `let in` expression has to be at the beggining of your configuration.nix file, before anything else is declared
#the first curly brace represent your usual beggining of a configuration.nix file
let  
  asusWmiScreenpad = config.boot.kernelPackages.callPackage ./asus-wmi-screenpad.nix { };  
in  
{
  #the rest of your configuration

  #include the custom kernel module 
  boot.extraModulePackages = [ asusWmiScreenpad ];  
  
  #load module during boot
  boot.kernelModules = [ "asus_wmi_screenpad" ];   
  
  # *Optional but recommended* 
  # enable changing brightness without giving permission everytime after reboot  
  services.udev.extraRules = ''  
    ACTION=="add", SUBSYSTEM=="leds", KERNEL=="asus::screenpad", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/leds/%k/brightness"  
  '';  
  
} #end of your configuration.nix file 
```

3. Prefetch the needed patch depending on kernel version from `prepare-for-current-kernel.sh` using `curl`. 

4. Run `sudo nixos-rebuild switch --option sandbox false`


If you encounter any problems, feel free to open an issue, as this is by no means a production level module. Also, feel free to contribute in order to make this up to the nix standard in its entirety.
