{ stdenv, fetchzip, fetchurl, kernel, lib, unzip, wget }:

stdenv.mkDerivation rec {
  pname = "asus-wmi-screenpad";
  version = "1.0"; 

  src = fetchzip {
    #url = "https://github.com/Plippo/asus-wmi-screenpad/archive/master.zip";
    #url = "https://github.com/joyfulcat/asus-wmi-screenpad/archive/master.zip";
    #sha256 = "sha256-np7ILw6JhmFE6iS6HLuTJ1/OnjIph5UYj8Vs3/PBRdA="; 
    #sha256 = "sha256-EmM9L7thAkHe2iBPrdPaK93TXOIN95Si1TLFOuqthgo="; #joyfulcat
    url = "https://github.com/joyfulcat/asus-wmi-screenpad/archive/master.zip";
    sha256 = "sha256-owy7giOtHNW7htxIZ3kByWzYJeQdu/fjkQF7jN2rlmg=";
  };

  nativeBuildInputs = [ kernel unzip wget ];

  __noChroot = true;

  patchPhase = ''
    sh prepare-for-current-kernel.sh
  '';

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp asus-wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
    cp asus-nb-wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  postInstall = ''
    # Instructions for setting device permissions and usage
    # This will need to be handled outside the Nix build, like udev rules which go into configuration.nix
    # Refer to ... for example on setting udev rules 
    echo "Remember to set permissions and manage device interaction as needed."
  '';

  meta = with lib; {
    description = "Asus WMI Driver for Screenpad";
    homepage = "https://github.com/joyfulcat/asus-wmi-screenpad";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ]; # Add your maintainer here
  };
}
