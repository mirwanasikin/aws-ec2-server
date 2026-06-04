{
  description = "Ansible Flakes with AWS SSM plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          ansible
          python3
          python3Packages.boto3
          python3Packages.botocore
        ];
        shellHook = ''
          ansible-galaxy collection install amazon.aws --upgrade 2>/dev/null
          echo "Ansible Siap!"
          ansible --version
        '';
      };
    };
}
