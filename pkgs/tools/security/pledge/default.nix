{ lib, fetchFromGitHub, runCommand }:

# TODO(ProducerMatt): verify executable's license block against a checksum for
# automated CYA when updating. One possible route:
#
# $ readelf -a o//tool/build/pledge.com.dbg |\
#    grep kLegalNotices |\
#    awk '{print $2}'
#
# Gets the hex address of where the licenses start. From there it's a double-nul
# terminated list of strings.
let
  commonMeta = rec {
    name = "pledge";
    version = "1.4"; # July 25th 2022
    rev = "${name}-${version}"; # looks redundant but useful if you want a specific Git commit
    system = "x86_64-linux";

    # NOTE(ProducerMatt): Cosmo embeds relevant licenses near the top of the
    # executable. You can manually inspect by viewing the binary with `less`.
    # Grep for "Copyright".
    #
    # At the time of this writing in MODE=rel: ISC for Cosmo, BSD3 for getopt
    licenses = with lib.licenses; [ isc bsd3 ];
    #e if compiling in MODE=asan or dbg, add licenses.zlib
  };
  cosmoMeta = {
    mode="rel";
    path="tool/build";
    target = "${commonMeta.name}.com";
    fullPath = "o/${cosmoMeta.mode}/${cosmoMeta.path}/${cosmoMeta.target}";
    make = "./build/bootstrap/make.com";
    platformFlag = # TODO: copy from other repo
      if commonMeta.system == "x86_64-linux"
      then ""#"CPPFLAGS=-DSUPPORT_VECTOR=0b00000001" # currently fails
        else "";
  };
  cosmoSrc = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = commonMeta.rev;
    sha256 = "FDyQC8WoTB1dRwRp+BRuV9k8QsZbX2A9SXKuVpX/11c=";
  };
in
  derivation {
    name = "${commonMeta.name}-${commonMeta.version}";
    system = commonMeta.system;
    builder = runCommand "build" {
      src = cosmoSrc; # TODO: copy only needed files
      } ''
      ls -la
      cp -r ${cosmoSrc} ./cosmo
      chmod -R +wx cosmo
      cd cosmo
      sh ./build/bootstrap/cocmd.com --assimilate
      sh ./build/bootstrap/make.com --assimilate
      ${cosmoMeta.make} MODE=${cosmoMeta.mode} -j$NIX_BUILD_CORES \
          ${cosmoMeta.platformFlag} V=0 \
          ${cosmoMeta.fullPath}
      mkdir $out
      mkdir $out/bin
      ${cosmoMeta.fullPath} --assimilate
      cp ${cosmoMeta.fullPath} $out/bin/${commonMeta.name}
      '';

    outputs = [ "out" ];
  } //
  {
    meta = {
      description = "Easily launch linux commands in a sandbox inspired by the design of openbsd's pledge() system call.";
      homepage = "https://justine.lol/pledge/";
      platforms = [ commonMeta.system ];
      maintainers = with lib.maintainers; [ ProducerMatt ];
    };
  }
