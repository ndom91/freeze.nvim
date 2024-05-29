{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nvim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, nvim-nightly }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          common = with pkgs; [
            alejandra
            lua-language-server
            stylua
            luajitPackages.luacheck
            nvim-nightly.packages.${pkgs.system}.default
            vimPlugins.plenary-nvim
            charm-freeze
          ];

          # runtime Deps
          libraries = with pkgs;[
          ] ++ common;

          # compile-time deps
          packages = with pkgs; [
          ];
        in
        with pkgs;
        {
          devShells.default = mkShell {
            name = "freeze.nvim-dev-shell";
            nativeBuildInputs = packages;
            buildInputs = libraries;
          };
        }
      );
}
