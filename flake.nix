{
  nixConfig.bash-prompt = "[nix-develop-sydtest-large-diffs:] ";
  description = "Sydtest large diffs example";
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    horizon-platform = {
      url = "git+https://gitlab.homotopic.tech/horizon/horizon-platform";
    };
    sydtest = {
      url = "git+https://github.com/NorfairKing/sydtest?ref=faster-diffs";
    };
  };
  outputs =
    inputs@
    { self
    , flake-utils
    , horizon-platform
    , nixpkgs
    , sydtest
    , ...
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [sydtest.overlays.x86_64-linux]; };
      hsPkgs =
        with pkgs.haskell.lib;
        pkgs.haskell.packages.ghc942.override
          {
            overrides = hfinal: hprev:
              horizon-platform.packages.x86_64-linux // {
                sydtest-large-diffs-spec = disableLibraryProfiling (hprev.callCabal2nix "osl:spec" ./. { });
              };
          };
    in
    {
      checks = { spec = hsPkgs.sydtest-large-diffs-spec; };
    });

}
