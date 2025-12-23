default:
    @just --list

switch:
    home-manager switch --flake .#xavier

setup-system:
    @echo "Installing system dependencies (apt)..."

    
    sudo apt update
    #make clangd-20 global clangd
    sudo apt install -y clangd-20
    sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-20 100

    sudo apt install -y python3 \
        apt-utils clang diffutils openssl \
        build-essential cmake

    @echo "System dependencies synced."

update-all: setup-system switch
    @echo "Fully synced."
