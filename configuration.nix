# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "bgvit"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Activate KDE Plasma
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # if necessary, use the command below to ensure the use of x11
  # services.xserver.displayManager.defaultSession = "plasma"

 services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
   khelpcenter
   konsole
   elisa
 ];

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bgvit = {
    isNormalUser = true;
    description = "bgvit";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "bgvit";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # virtualisation.docker = { 
  #   enable = true;
  # };
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Add NUR: https://github.com/nix-community/NUR
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libsForQt5.ark
    nix-update
    kitty
    home-manager
    wget
    service-wrapper
    curl
    lsof
    busybox
    stow
    gnupg
    exa
    bat
    htop
    git
    tmux
    fzf
    ffmpeg
    vivaldi
    standardnotes
    tdesktop
    calibre
    spotify
    vlc
    yt-dlp
    droidcam
    temurin-bin-11
    kotlin
    elixir
    go
    rustc
    nodejs
    elmPackages.elm
    neovim
    vscode
    redli
    redis
    jetbrains.idea-community
    jetbrains.idea-ultimate
    gradle
    maven
    android-tools
    dbeaver
    postman
    docker
    docker-compose
    slack
    discord
    teams
    cinny-desktop
    graalvm17-ce
    krita
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Why do I get an error message about ca.desrt.dconf or dconf.service? https://nix-community.github.io/home-manager/index.html
  programs.dconf.enable = true;

  # List services that you want to enable:
  
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  
  # enable DRM from nvidia: this is a requirement to activate wayland
  # hardware.nvidia.modesetting.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
