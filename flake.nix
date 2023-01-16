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
    sydtest-src = {
      url = "git+https://github.com/NorfairKing/sydtest";
    };
  };
  outputs =
    inputs@
    { self
    , flake-utils
    , horizon-platform
    , nixpkgs
    , sydtest-src
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
      hsPkgs =
        with pkgs.haskell.lib;
        horizon-platform.legacyPackages.${system}.override
          {
            overrides = hfinal: hprev:
              {
                sydtest-large-diffs-spec = disableLibraryProfiling (hprev.callCabal2nix "osl:spec" ./. {});
                sydtest = hprev.callCabal2nix "sydtest" (inputs.sydtest-src + /sydtest) {};
              };
          };
    in
    {
      checks = { spec = hsPkgs.sydtest-large-diffs-spec; };
    });

}
