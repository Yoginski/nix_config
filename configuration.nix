# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  services.locate.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.extraHosts =
    ''
    '';

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Bishkek";

  programs.bash = {
    enableCompletion = true;
    promptInit = ''
      if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
      fi
    '';
  };

  environment.variables = {
    GOROOT = [ "${pkgs.go.out}/share/go" ];
    BROWSER = [ "firefox" ];
    EDITOR = [ "vim" ];
  };

  environment.systemPackages = with pkgs; [
    rofi i3blocks xtitle networkmanagerapplet scrot compton
    wget nmap bind lsof lm_sensors acpi xorg.xbacklight
    htop file python27Full bc
    gimp libreoffice celt
    vim termite git vifm archivemount emacs
    firefox cutegram apvlv
    openssl patchelf
    go ruby stack gnumake gcc
    python2
    python2Packages.pip
    python2Packages.mitmproxy
    python3
    python3Packages.pip
    rustc cargo rustracer rustfmt
    virtmanager remmina
    zlib zlibStatic ncurses cmake

    rogue
  ];

  nixpkgs.config = {
    allowUnfree = true;

    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };
  };

  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.synaptics.enable = true;
  services.xserver.synaptics.twoFingerScroll = true;
  services.xserver.synaptics.tapButtons = false;
  services.xserver.displayManager.slim.defaultUser = "prowler";

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      font-awesome-ttf
      ubuntu_font_family
      unifont
      source-code-pro
      inconsolata-lgc
    ];
  };

  users.extraUsers.prowler = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" ];
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  system.stateVersion = "unstable";
}
