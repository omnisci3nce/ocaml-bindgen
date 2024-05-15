{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    clangml = {
      url = "github:thierry-martinez/clangml/main";
      flake = false;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: 
      let 
          inherit (pkgs) ocamlPackages mkShell lib;
      in
      {
        packages = {
          default = ocamlPackages.buildDunePackage {
            version = "dev";
            pname = "bindgen";
            propagatedBuildInputs = with ocamlPackages; [
              inputs'.clangml.packages.default # It does *not* like this. I guess this is only for other repos with flake.nix
            ];
          };
        };

        devShells = {
          default = pkgs.mkShell {
            inputsFrom = [
              self'.packages.default
            ];
            packages = with pkgs; [
              llvmPackages_15.llvm
              ncurses
            ];
            buildInputs = with ocamlPackages; [
              ocaml
              ppxlib
              stringext
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
