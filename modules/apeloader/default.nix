{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.apeloader;
  apeElfLoader = ./ape.elf;
in
{
  options.programs.apeloader = {
    enable = mkEnableOption "APE helper/loader";
    mode = mkOption {
      type = types.str;
      default = "loader";
      description = ''
        If "loader" (default), use the APE loader to speed up execution of APE
        binaries. If "workaround", use a simple redirect to a Bourne shell to
        help resolve some execution issues.
      '';
    };
  };
  config = {
  boot.binfmt.registrations."APE" = mkIf cfg.enable
    (if cfg.mode == "loader" then
      {
        recognitionType = "magic";
        magicOrExtension = "MZqFpD";
        interpreter = "${apeElfLoader}";
      }
     else {
       # APE helper (not ape loader)
       # FIXME NOT WORKING LAST I CHECKED
       recognitionType = "magic";
       magicOrExtension = "MZqFpD";
       interpreter = "${pkgs.bash}/bin/sh";
     });
  };
}
