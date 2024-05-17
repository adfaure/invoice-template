{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in rec {
        formatter = pkgs.alejandra;
        packages = {
        };
        devShells = let
          fonts_opentype = with pkgs; [
            fira
            fira-mono
            libertinus
          ];
          fonts_truetype = with pkgs; [
            fira-code
            inconsolata
          ];
          fonts = fonts_opentype ++ fonts_truetype;
          fonts_opentype_paths = map (x: "${x}/share/fonts/opentype") fonts_opentype;
          fonts_truetype_paths = map (x: "${x}/share/fonts/truetype") fonts_truetype;
          fonts_paths = pkgs.lib.strings.concatStringsSep ":" (fonts_opentype_paths ++ fonts_truetype_paths);
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs;
              [
                typst
                typst-lsp
                fira
                fira-code
                lmodern
                lmmath
                libertinus
                open-sans
                carlito
                liberation_ttf
                ubuntu_font_family
                roboto
                noto-fonts
                lato
              ]
              ++ fonts;
            TYPST_FONT_PATHS = fonts_paths;
          };
        };
      }
    );
}
