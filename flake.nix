{
  description = "Python Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    devshell,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [devshell.overlays.default];
      };

      myPython = pkgs.python310.withPackages (p:
        with p; [
          rich
          pygments
        ]);
    in {
      devShell = pkgs.devshell.mkShell {
        name = "Python Environment";

        packages = with pkgs; [
          myPython
          texlab
        ];

        # Use $1 for positional args
        # commands = [
        # ];
      };
    });
}
