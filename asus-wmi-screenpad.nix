{ stdenv, fetchzip, fetchurl, kernel, lib, unzip, wget }:

stdenv.mkDerivation rec {
  pname = "asus-wmi-screenpad";
  version = "1.0"; 

  src = fetchzip {
    url = "https://github.com/joyfulcat/asus-wmi-screenpad/archive/master.zip";
    sha256 = "sha256-owy7giOtHNW7htxIZ3kByWzYJeQdu/fjkQF7jN2rlmg=";
  };

  nativeBuildInputs = [ kernel unzip wget ];

  __noChroot = true;

  patchPhase = ''
    # Only run if your kernel version requires it
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
    # This will need to be handled outside the Nix build, perhaps with udev rules or manual steps
    echo "Remember to set permissions and manage device interaction as needed."
  '';

  meta = with lib; {
    description = "Asus WMI Driver for Screenpad";
    homepage = "https://github.com/joyfulcat/asus-wmi-screenpad";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ]; # Add your maintainer here
  };
}
