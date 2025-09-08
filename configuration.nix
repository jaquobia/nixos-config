# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  # unstable, quiba-pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "quiba-nixos"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
  networking.firewall.interfaces.wlp5s0.allowedTCPPorts = [ 25565 49042 ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.quiba = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Jaquobia";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "fmod"
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "obsidian"
        "vintagestory"
        "sm64coopdx"
      ];
    permittedInsecurePackages = [
      # Required by Vintage Story
      "dotnet-runtime-7.0.20"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SYSTEMD_EDITOR = "nvim";
      AMD_VULKAN_ICD = "RADV";
    };
    systemPackages = with pkgs; [

      # System tools
      # alsa-utils
      amdgpu_top
      btop
      dunst
      fd
      fzf
      gptfdisk
      gparted
      keepassxc
      nix-tree
      pavucontrol
      polkit_gnome
      sxiv
      ripgrep
      tree
      unzip
	  _7zz
      wget
      wlroots
      wl-clipboard
      xorg.xprop

      # Desktop Choices
      afetch
      leaf
      afterglow-cursors-recolored
      bash
      file-roller
      sway-contrib.grimshot
      image-roll
      jetbrains.idea-community
      krita
      unstable.neovim
      neovide
      nwg-look
      obsidian
	  qbittorrent
      unstable.satty
      starship
      swww
      vesktop
      vimix-cursors
      waypaper
      wezterm
      yazi
      # xdg-desktop-portal-termfilechooser
      zathura

      # Games
      blockbench
      quiba.doomseeker
      unstable.gale
      gamemode
      ## For a fucking chrome-embedded minecraft mod
      libcef
      # nss
      # lutris
      mangohud
      prismlauncher
      protonup-qt
      unstable.vintagestory
      # satisfactorymodmanager
      sm64baserom
      quiba.sm64coopdx
      quiba.zandronum
      sladeUnstable

      # Nix Tooling
      nil
      nixd
      nixfmt-rfc-style

      # Lua Tooling
      lua-language-server

      # Bash Tooling
      bash-language-server

      # C Tooling
      ccls
      cmake-language-server

      # Rust Tooling
      rust-analyzer
      rustup

      # Zig Tooling
      zig
      zls

      # Java Tooling
      jdt-language-server

      # Json Tooling
      spectral-language-server
      jsonfmt

      # GLSL Tooling
      glsl_analyzer

      # Vulkan Tooling
      vulkan-headers
      vulkan-validation-layers
      vulkan-tools
    ];
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
    nerd-fonts._0xproto
    nerd-fonts.departure-mono # pixel font
    monocraft # minecraft pixel font
    miracode # vectorized monocraft
    scientifica # pixel font
    curie # readable scientifica
    jetbrains-mono
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [ libva ];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  programs = {
    dconf.enable = true;

    zsh.enable = true;
    fzf.fuzzyCompletion = true;
    git.enable = true;
    ssh.startAgent = true;
    lazygit = {
      enable = true;
    };
    sway.enable = true;
    niri.enable = true;
    firefox.enable = true;
    # yazi = {
    # 	package = unstable.yazi;
    # 	enable = true;
    # };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        # thunar-volman
      ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    obs-studio = {
      enable = true;
    };
    waybar = {
      enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        openssl
        alsa-lib
        glibc
        libgcc
        wayland
        libxkbcommon
        vulkan-headers
        vulkan-loader
        libGL
        libGLU
        SDL2
      ];
    };
  };

  services = {
    # Required for thunar-volman
    gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      # alsa.support32Bit = false;
      pulse.enable = true;
    };
    blueman.enable = false;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "poklit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  xdg.portal.config = {
    # sway = {
    # 	default = ["gtk"];
    # 	"org.freedesktop.impl.portal.FileChooser"=["termfilechooser"];
    # 	"org.freedesktop.impl.portal.ScreenCast"=["wlr"];
    # 	"org.freedesktop.impl.portal.Screenshot"=["wlr"];
    # };
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
