{
  description = "CV Generator with Node.js setup using Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    # Define the system architecture (e.g., x86_64-linux)
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in{
    # Define packages for backend and frontend
    packages.${system} = {
      # Backend package
      backend = pkgs.stdenv.mkDerivation rec {
        pname = "cv-generator-backend";
        version = "1.0.0";

        # Source directory for the backend
        src = ./backend;

        # Use node2nix to manage dependencies
        buildInputs = [ pkgs.nodejs pkgs.nodePackages.node2nix ];

        # Install dependencies via node2nix
        preBuild = ''
          node2nix --input package.json --lock package-lock.json --output node-packages.nix
        '';

        buildPhase = ''
          npm install --production
        '';

        installPhase = ''
          mkdir -p $out
          cp -r * $out
        '';
      };

      # Frontend package
      frontend = pkgs.stdenv.mkDerivation rec {
        pname = "cv-generator-frontend";
        version = "1.0.0";

        # Source directory for the frontend
        src = ./frontend;

        # Use node2nix to manage dependencies
        buildInputs = [ pkgs.nodejs pkgs.nodePackages.node2nix ];

        preBuild = ''
          node2nix --input package.json --lock package-lock.json --output node-packages.nix
        '';

        buildPhase = ''
          npm install --production
          npm run build
        '';

        installPhase = ''
          mkdir -p $out
          cp -r build/* $out/
        '';
      };
    };

    # Development shell combining backend and frontend environments
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.nodejs             # Add Node.js globally in shell
        pkgs.nodePackages.node2nix # Add node2nix for dependency management
      ];
    };
  };
}
