{
  description = "Infinite desktop panning for Hyprland";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "hyprland-infinite-desktop";
        version = "1.0.0";
        src = ./.;

        nativeBuildInputs = [ pkgs.makeWrapper ];
        buildInputs = [ (pkgs.python3.withPackages (ps: [ ps.evdev ])) ];

        installPhase = ''
          mkdir -p $out/bin
          cp infinite_desktop_core.py $out/bin/
          cp *.sh $out/bin/

          chmod +x $out/bin/*

          for script in $out/bin/*.sh; do
            wrapProgram "$script" \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.python3 pkgs.hyprland pkgs.coreutils ]}
          done
          
          mv $out/bin/infinite-desktop.sh $out/bin/infinite-desktop
          mv $out/bin/infinite-desktop-toggle.sh $out/bin/infinite-desktop-toggle
        '';
      };
    };
}