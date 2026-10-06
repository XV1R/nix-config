# Profound work infrastructure: trust the company binary cache's signing
# key, and offload aarch64-linux builds to the shared builder. The
# builder's SSH host alias and credentials are set up outside Nix.
{
  flake.modules.darwin.profound = {
    nix.settings.extra-trusted-public-keys = [
      "profound-nix-binary-cache-1:f1ZchuV4BJnwqQIn0RJlIRkzTFgUrFZNRkBW6sZfDqk="
    ];

    nix.distributedBuilds = true;
    nix.buildMachines = [
      {
        hostName = "binshelf-builder";
        protocol = "ssh-ng";
        system = "aarch64-linux";
        maxJobs = 2;
        speedFactor = 1;
        supportedFeatures = ["benchmark" "big-parallel" "gccarch-armv8-a" "kvm" "nixos-test"];
      }
    ];
  };
}
