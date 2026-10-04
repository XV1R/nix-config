# Host side of the MicroVM setup (saturn runs the VMs).
# Guests live in ./<name>/ and are declared fully declaratively here.
{inputs, ...}: {
  microvm.autostart = ["minecraft"];

  microvm.vms.minecraft = {
    specialArgs = {inherit inputs;};
    # null = instantiate the guest's own package set, so the guest's
    # nixpkgs.overlays (nix-minecraft) and allowUnfree actually apply.
    pkgs = null;
    config = import ./minecraft;
  };

  # ~/minecraft is the user's data folder (worlds, logs, mod jars). Expose
  # it to the VM via a bind mount so the virtiofsd share can read it
  # without loosening /home/xavier's 0700 permissions: accessing
  # /srv/minecraft bypasses /home/xavier traversal entirely.
  fileSystems."/srv/minecraft" = {
    device = "/home/xavier/minecraft";
    fsType = "none";
    options = ["bind"];
  };
}
