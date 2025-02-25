{
  description = "CV Generator with Node.js setup using Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs"; # Use the latest NixOS package set
  };

  outputs = { self, nixpkgs }: {
    packages = {
      # Backend package
      backend = nixpkgs.mkNodePackage {
        name = "cv-generator-backend";
        src = ./backend;
        # Specify Node.js version and dependencies
        nodejs = nixpkgs.nodejs; # Use Node.js LTS version (adjust as needed)
      };

      # Frontend package
      frontend = nixpkgs.mkNodePackage {
        name = "cv-generator-frontend";
        src = ./frontend;
        # Specify Node.js version and dependencies
        nodejs = nixpkgs.nodejs;
      };
    };

    # Development shell for both backend and frontend
    devShells.default = nixpkgs.mkShell {
      buildInputs = [
        self.packages.backend
        self.packages.frontend
        nixpkgs.nodejs # Add Node.js globally for shell use
      ];
    };
  };
}
