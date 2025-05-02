# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, unstable, quiba-pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "quiba-nixos"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config = {
  	allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    		"steam"
    		"steam-original"
    		"steam-unwrapped"
    		"steam-run"
    		"obsidian"
		"vintagestory"
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
		wget
		tree
		# alsa-utils
		afterglow-cursors-recolored
		bash
		btop
		blockbench
		quiba-pkgs.doomseeker
		dunst
		file-roller
		unstable.gale
		gptfdisk
		gparted
		sway-contrib.grimshot
		image-roll
		krita
		#lxappearance
		# For a fucking chrome-embedded minecraft mod
		libcef
		lutris
		mangohud
		unstable.neovim
		nix-tree
		nss
		nwg-look
		obsidian
		pavucontrol
		polkit_gnome
		prismlauncher
		rustup
		unstable.satty
		starship
		swww
		sxiv
		unzip
		vesktop
		vimix-cursors
		vulkan-headers
		vulkan-validation-layers
		vulkan-tools
		wezterm
		waypaper
		wl-clipboard
		unstable.yazi
		quiba-pkgs.zandronum
		zathura
		zig
		zls
	];
};

fonts.enableDefaultPackages = true;
fonts.packages = with pkgs; [
	nerdfonts
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
	git.enable = true;
	ssh.startAgent = true;
	lazygit = {
		package = unstable.lazygit;
		enable = true;
	};
	sway.enable = true;
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
		package = unstable.waybar;
		enable = true;
	};
};

services = {
	# Required for thunar-volman
	# gvfs.enable = true;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true;
  };

  # List services that you want to enable:

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
