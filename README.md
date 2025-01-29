### What is this?

An adaptation of the [asus-wmi-screenpad](https://github.com/Plippo/asus-wmi-screenpad) kernel module to a nix derivation. This is a work in progress with ideal nixpkgs upstreaming in the near future. Feel free to open PR if you want to contribute.

Before trying to run this, it's worth taking a look at the [original documentaion](https://github.com/Plippo/asus-wmi-screenpad/blob/master/README.md) to understand better how the module works.

### How to use? 

1. Clone the repository or copy `asus-wmi-screenpad.nix` directly and save it in `/etc/nixos/`

2. Make the following changes in `configuration.nix`:

```
#the `let in` expression has to be at the beginning of your configuration.nix file, before anything else is declared
#the first curly brace represent your usual beginning of a configuration.nix file
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

3. Run `sudo nixos-rebuild switch`

### Having problems?

Currently this is working fine for me on nixos (stable) 24.11. Please note that if you are running a very new kernel this might not
 work, currently working to address this in the next release. If you encounter any problems, feel free to open an issue.
