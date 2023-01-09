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
  };
  outputs =
    inputs@
    { self
    , flake-utils
    , horizon-platform
    , nixpkgs
    , ...
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
      hsPkgs =
        with pkgs.haskell.lib;
        pkgs.haskell.packages.ghc942.override
          {
            overrides = hfinal: hprev:
              horizon-platform.packages.x86_64-linux // {
                sydtest-large-diffs = dontCheck (disableLibraryProfiling (hprev.callCabal2nix "sydtest-large-diffs" ./. { }));
                sydtest-large-diffs-spec = disableLibraryProfiling (hprev.callCabal2nix "osl:spec" ./. { });
              };
          };
    in
    {
      packages.default = hsPkgs.sydtest-large-diffs;
      checks = { spec = hsPkgs.sydtest-large-diffs-spec; };
    });

}
