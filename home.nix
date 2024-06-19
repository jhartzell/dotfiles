{ config, pkgs, ... }:

{
  home.username = "zyph";
  home.homeDirectory = "/home/zyph";
  home.stateVersion = "23.11";

  xdg.configFile = {
    "rofi" = {
     source = config.lib.file.mkOutOfStoreSymlink "/home/zyph/dotfiles/.config/rofi";
    };
  };

  home.packages = with pkgs; [
    zsh
    alacritty
    firefox
    magic-wormhole
    vscode
    btop
    rofi-wayland # Rofi for Wayland (App launcher)
    spotify
    google-chrome
    vesktop
    slack
    telegram-desktop
    bitwarden # Password manager
    playerctl # Media player control
    xfce.thunar # File manager

    # Nix LSP for vscode
    nixpkgs-fmt
    nil

    wlroots

    mongodb-compass

    # Keyring stuff
    libsecret
    gnome.seahorse
    gnome.gnome-keyring
    gcr
  ];

  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "thunar";
      "$menu" = "rofi -show";
      "$menuEmoji" = "rofi -modi 'emoji:rofimoji' -show emoji";

      # Some default env vars.
      env = "XCURSOR_SIZE,24,QT_QPA_PLATFORMTHEME,qt5ct";

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindoww"
        "$mainMod, mouse:273, resizewindow"
      ];

      input = {
        kb_layout = "us";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = "no";
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      animations = {
        enabled = true;
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        drop_shadow = "yes";
        shadow_range = 4;
        shadow_render_power = 3;
        # col.shadow = "rgba(1a1a1aee)";
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = "yes"; # you probably want this
      };

      master = {
        new_is_master = true;
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # col.inactive_border = "rgba(595959aa)";

        layout = "dwindle";

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;
      };

      bind = [
        "$mainMod, C, killactive"
        "$mainMod, Q, exec, alacritty"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus"

        "$mainMod, SPACE, exec, $menu"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"

        ", xf86audioraisevolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", xf86audiolowervolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", xf86audiomute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"
      ];
    };
  };

}
