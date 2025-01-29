{ lib
, stdenv
, fetchzip
, fetchurl
, kernel
}:

let
  baseKernelVersion = with lib; 
    let
      versionParts = splitString "." kernel.version;
      major = head versionParts;
      minor = elemAt versionParts 1;
    in "${major}.${minor}";

  # Comprehensive hash mapping for all supported kernel versions
  kernelSourceHashes = {
    "5.4" = {
      "asus-wmi.c" = "0mr3g20rz46gc7ikiffwbsvnhjn8j2l9kschycsvaibs5c1k2ndb";
      "asus-wmi.h" = "1vbj4a4f6fbypkcqpfc4dcmaj2cwqzgmiaq2iw8r5jj8mv9j1amc";
      "asus-nb-wmi.c" = "1vicz1mkbmmgm85dyjx7gw089p3clz63ra7sawh54p0vspgw14wx";
    };
    "5.5" = {
      "asus-wmi.c" = "08jqhm13giih881qilk4ky12pga5yvp028ak486s05zf5m4v6anw";
      "asus-wmi.h" = "15gp62lkgnqm7dcraz7pzl3c2wvf0jdsnvfaw6alwbsfsyvc0587";
      "asus-nb-wmi.c" = "112z2w148lvrv2f7ph5k3kf7w6xw7558f5p5vypipr614zjdi3b9";
    };
    "5.6" = {
      "asus-wmi.c" = "03xij6lwvdpgd5297fhkr1hq6mnmg99rpfqc7ss4i1ljr2ypwvvb";
      "asus-wmi.h" = "15gp62lkgnqm7dcraz7pzl3c2wvf0jdsnvfaw6alwbsfsyvc0587";
      "asus-nb-wmi.c" = "0gvv4fn7f4f7mqdc238iw5yh0gww47k2c24hdjiga0kk7byv0g73";
    };
    "5.7" = {
      "asus-wmi.c" = "0lpiv0pp9vg8iw0q4ihjkihsbvisny199kzalj9ssh7fbjzhz2g3";
      "asus-wmi.h" = "15gp62lkgnqm7dcraz7pzl3c2wvf0jdsnvfaw6alwbsfsyvc0587";
      "asus-nb-wmi.c" = "1hg3csf521r9yw5innjd9jzfhqr224liyxd1drbdbl3zclq5jz4y";
    };
    "5.8" = {
      "asus-wmi.c" = "1hwa2p502gbf2867vk008dfs0mrv7a3fm1z4jks8x3rz5dqfiild";
      "asus-wmi.h" = "13db762xg0fs0rfly2bm4kqcxdac5l8rs7sx0slbi68hnk0vzifk";
      "asus-nb-wmi.c" = "1n56py45qrqz8hh90l4k7hbqfsf42sf84nxabinys6v9mhgvzjkb";
    };
    "5.9" = {
      "asus-wmi.c" = "1b5pf2dvgnpqzk3mg0mi0y68k09glghllk4bnn77pxic3q19r5s2";
      "asus-wmi.h" = "13db762xg0fs0rfly2bm4kqcxdac5l8rs7sx0slbi68hnk0vzifk";
      "asus-nb-wmi.c" = "11hq2dqdf4i2fs5gj1aqzwhv21ywqgp1q0bas9kn54w15mnbwh09";
    };
    "6.0" = {
      "asus-wmi.c" = "1bnk6a87sl2r36bajp5w92gzwq38l92sm6riwlfs2c3zhnlpnsp6";
      "asus-wmi.h" = "00y1mph2lc7dakhia6ixpbgyffnaasrnj57qzgd4wrxjh6lvfvyb";
      "asus-nb-wmi.c" = "19l0v052cy8mx0y1zqr7sqsfgc63hl441ml56xifvnpf6j42xyfa";
    };
    "6.1" = {
      "asus-wmi.c" = "0dl4n4cg54gvrslclhj6prm1pcbp7ckrc8i0r8m1yxnlsfqn2jnj";
      "asus-wmi.h" = "1cg34y36s11j4qah92w5rkdg3zh76q9icbs8i2b3qkkp63pbxvig";
      "asus-nb-wmi.c" = "1ib090a7idmr68wgf2pwvgydhbwxzfmq172n62rikpm8b1gms0dc";
    };
    "6.2" = {
      "asus-wmi.c" = "16wz0dd2k8fbxkc3rl7s0jq1nq6p79aibwxgxlxaji1p1yxq192w";
      "asus-wmi.h" = "105kpzp1y5zs2aj9cw607nyq5bzp49kfgnj1q51sz1iahqijrfaz";
      "asus-nb-wmi.c" = "159li5as5b03phk1h1gfnmi9v93hilywpc1svims5vx0nqi5v4vy";
    };
    "6.3" = {
      "asus-wmi.c" = "16wz0dd2k8fbxkc3rl7s0jq1nq6p79aibwxgxlxaji1p1yxq192w";
      "asus-wmi.h" = "105kpzp1y5zs2aj9cw607nyq5bzp49kfgnj1q51sz1iahqijrfaz";
      "asus-nb-wmi.c" = "1j7c2zzhlqyp2f6baq035h6ajalgqhzil50dvwfavnggwaiji9xx";
    };
    "6.4" = {
      "asus-wmi.c" = "1gjzqdxfywpq63vmi39wwwxkphr93a5ra6j5xzmz0dbsyp4xjndl";
      "asus-wmi.h" = "105kpzp1y5zs2aj9cw607nyq5bzp49kfgnj1q51sz1iahqijrfaz";
      "asus-nb-wmi.c" = "1j7c2zzhlqyp2f6baq035h6ajalgqhzil50dvwfavnggwaiji9xx";
    };
    "6.5" = {
      "asus-wmi.c" = "00yr4gfnm8l51jqk9awaywxd1822am32i9j4v73078f7r7hm7mjr";
      "asus-wmi.h" = "1cg34y36s11j4qah92w5rkdg3zh76q9icbs8i2b3qkkp63pbxvig";
      "asus-nb-wmi.c" = "1g50wc1qchi6fv5jh7lmzlp9qvmgrl6ja1v0293mkid4g22mhc28";
    };
    "6.6" = {
      "asus-wmi.c" = "1mrqq79b8dj3pcfhw0ysnv7q2dk0vlrz97p9jf6ay25gfazzf24d";
      "asus-wmi.h" = "1cg34y36s11j4qah92w5rkdg3zh76q9icbs8i2b3qkkp63pbxvig";
      "asus-nb-wmi.c" = "1ib090a7idmr68wgf2pwvgydhbwxzfmq172n62rikpm8b1gms0dc";
    };
    "6.7" = {
      "asus-wmi.c" = "0x79ifm4xiaf96vicqhscca4qnxlhqia6gfm5b4md65fr2g216k6";
      "asus-wmi.h" = "08b7acx7qq173k75vj97070v25xj7mrw1l82s88md6z98avsf3yq";
      "asus-nb-wmi.c" = "17zlc1c4bk03abqxw63d6i4fbgp8x1f3p822vlsggq1ngg7lkapr";
    };
    "6.8" = {
      "asus-wmi.c" = "1ij2bnva29d043amxkbha0j068cgm6lr3chx278rvh4msk20hps5";
      "asus-wmi.h" = "08b7acx7qq173k75vj97070v25xj7mrw1l82s88md6z98avsf3yq";
      "asus-nb-wmi.c" = "17zlc1c4bk03abqxw63d6i4fbgp8x1f3p822vlsggq1ngg7lkapr";
    };
  };
# Verify kernel version is supported
  assertKernelSupported = version:
    if ! kernelSourceHashes ? ${version} then
      throw "Kernel version ${version} is not supported. Supported versions: ${toString (builtins.attrNames kernelSourceHashes)}"
    else version;

  # Get appropriate patch file based on kernel version
  getPatch = version:
    let
      v = lib.versions.majorMinor version;
    in
    if lib.versionOlder v "5.7" then "patch"
    else if lib.versionOlder v "5.99" then "patch5.8"
    else if lib.versionOlder v "6.2" then "patch6.0"
    else "patch6.2";

  # Verify and get kernel version
  kernelVersion = assertKernelSupported baseKernelVersion;

  # Fetch kernel sources with proper hashes
  kernelSources = {
    "asus-wmi.c" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-wmi.c?h=linux-${kernelVersion}.y";
      sha256 = kernelSourceHashes.${kernelVersion}."asus-wmi.c";
    };
    "asus-wmi.h" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-wmi.h?h=linux-${kernelVersion}.y";
      sha256 = kernelSourceHashes.${kernelVersion}."asus-wmi.h";
    };
    "asus-nb-wmi.c" = fetchurl {
      url = "https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/drivers/platform/x86/asus-nb-wmi.c?h=linux-${kernelVersion}.y";
      sha256 = kernelSourceHashes.${kernelVersion}."asus-nb-wmi.c";
    };
  };

in stdenv.mkDerivation rec {
  pname = "asus-wmi-screenpad";
  version = "1.0";

  src = fetchzip {
    url = "https://github.com/joyfulcat/asus-wmi-screenpad/archive/master.zip";
    sha256 = "sha256-owy7giOtHNW7htxIZ3kByWzYJeQdu/fjkQF7jN2rlmg=";
  };

  nativeBuildInputs = [ kernel ];

  postUnpack = ''
    cp ${kernelSources."asus-wmi.c"} $sourceRoot/asus-wmi.c
    cp ${kernelSources."asus-wmi.h"} $sourceRoot/asus-wmi.h
    cp ${kernelSources."asus-nb-wmi.c"} $sourceRoot/asus-nb-wmi.c
  '';

  patchPhase = ''
    echo "Kernel version: ${baseKernelVersion}"
    echo "Using patch: ${getPatch baseKernelVersion}"
    patch -p1 < "${getPatch baseKernelVersion}"
  '';

  buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    cp asus-wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
    cp asus-nb-wmi.ko $out/lib/modules/${kernel.modDirVersion}/extra/
  '';

  meta = with lib; {
    description = "ASUS WMI Driver for Screenpad";
    longDescription = ''
      This kernel module provides support for controlling the secondary screen
      (ScreenPad Plus) brightness on ASUS Zenbook Duo laptops.
      
      Supported kernel versions:
      - 5.4 to 5.6 (patch)
      - 5.8 to 5.99 (patch5.8)
      - 6.0 to 6.1 (patch6.0)
      - 6.2+ (patch6.2)
    '';
    homepage = "https://github.com/joyfulcat/asus-wmi-screenpad-nix";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ joyfulcat ];
    broken = !kernelSourceHashes ? ${baseKernelVersion};
  };
}

