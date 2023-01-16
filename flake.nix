{
  nixConfig.bash-prompt = "[nix-develop-sydtest-large-diffs:] ";
  description = "Sydtest large diffs example";
  inputs = {
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    nixpkgs.url = "github:nixos/nixpkgs/22.11";
    horizon-platform = {
      url = "git+https://gitlab.homotopic.tech/horizon/horizon-platform";
    };
    sydtest-src = {
      url = "git+https://github.com/NorfairKing/sydtest";
      flake = false;
    };
    safe-coloured-text-src = {
      url = "git+https://github.com/NorfairKing/safe-coloured-text";
      flake = false;
    };
  };
  outputs =
    inputs@
    { self
    , flake-utils
    , horizon-platform
    , nixpkgs
    , safe-coloured-text-src
    , sydtest-src
    }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; };
      hsPkgs =
        with pkgs.haskell.lib;
        nixpkgs.legacyPackages.x86_64-linux.haskell.packages.ghc902.override
          {
            overrides = hfinal: hprev:
              {
                sydtest-large-diffs-spec = disableLibraryProfiling (hprev.callCabal2nix "osl:spec" ./. {});
                sydtest = hprev.callCabal2nix "sydtest" (sydtest-src + /sydtest) { };
                autodocodec-yaml = markUnbroken (hprev.callHackage "autodocodec-yaml" "0.2.0.2" { });
                safe-coloured-text = hprev.callCabal2nix "safe-coloured-text" (safe-coloured-text-src + /safe-coloured-text) { };
              };
          };
    in
    {
      checks = { spec = hsPkgs.sydtest-large-diffs-spec; };
    });

}
