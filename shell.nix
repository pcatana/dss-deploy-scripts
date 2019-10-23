{ pkgsSrc ? (import ./nix/pkgs.nix {}).pkgsSrc
, pkgs ? (import ./nix/pkgs.nix { inherit pkgsSrc dapptoolsOverrides; }).pkgs
, dapptoolsOverrides ? {}
, dss-deploy ? null
, doCheck ? false
, githubAuthToken ? null
}@args: with pkgs;

let
  tdds = import ./. args;
  dapp2nix = import (fetchGit {
    url = "https://github.com/icetan/dapp2nix";
    ref = "json-specs";
    rev = "ce48c4b75f18dbd89321c6576842d2a48aab2e72";
  }) {};
in mkShell {
  buildInputs = tdds.bins ++ [
    tdds
    dapp2nix
    procps
  ];

  shellHook = ''
    setup-env() {
      . ${tdds}/lib/setup-env.sh
    }
    export -f setup-env
    setup-env || echo Re-run setup script with \'setup-env\'
  '';
}
