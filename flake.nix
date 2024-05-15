{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    clangml = {
      url = "github:thierry-martinez/clangml/main";
      flake = false;
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: 
      let 
          inherit (pkgs) ocamlPackages mkShell lib;

          clangml = ocamlPackages.buildDunePackage {
            pname = "clangml";
            version = "dev";
            src = pkgs.fetchFromGitHub {
              owner = "thierry-martinez";
              repo = "clangml";
              rev = "5651dedd52e32d721579ac7412d4404902584df3";
              sha256 = "sha256-kMQNulF8thYOicM9guNlNqtlWhxPoGeVD85T+GwBNkY=";
            };
            buildInputs = with pkgs; [];
          };
      in
      {
        packages = {
          default = ocamlPackages.buildDunePackage {
            version = "dev";
            pname = "bindgen";
            buildInputs = [
              # clangml ?
            ];
            propagatedBuildInputs = with ocamlPackages; [
              # clangml ?
            ];
          };
        };

        devShells = {
          default = pkgs.mkShell.override { stdenv = pkgs.clang17Stdenv; } {
            inputsFrom = [
              self'.packages.default
            ];
            packages = with pkgs; [
              llvmPackages_15.llvm
              ncurses
              clangml
            ];
            buildInputs = with ocamlPackages; [
              ocaml
              ppxlib
              stringext
              clangml
            ];
          };
        };

      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
