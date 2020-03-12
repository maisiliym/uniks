argz: with argz; ''
  exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
  # ## Variables

  # Logo key. Use Mod1 for Alt.
  set $mod Mod4

  # Home row direction keys, like vim
  set $left n
  set $down e
  set $up u
  set $right i

  # Quick and dirty theme
  client.focused          #665c54 #a65c54 #fdebc2 #2e9ef4 #a65c54
  client.focused_inactive #282828 #3f272a #eddbb2 #484e50 #5f676a
  client.unfocused        #3c3836 #3c3836 #a89984 #292d2e #222222
  client.urgent           #cc241d #cc241d #ebdbb2 #cc241d #cc241d
  client.placeholder      #000000 #0c0c0c #ffffff #000000 #0c0c0c

  mouse_warping container

  default_border pixel 5
  gaps inner 3
  gaps outer 2
  smart_gaps on
  hide_edge_borders smart_no_gaps

  input "1739:0:Synaptics_TM2927-001" {
      tap enabled
      natural_scroll enabled
      middle_emulation enabled
      accel_profile adaptive
  }

  input * {
    repeat_delay 250
    repeat_rate 35
  }

  ${optionalString iuzColemak ''
    input "1:1:AT_Translated_Set_2_keyboard" {
    xkb_layout us
    xkb_variant colemak
    xkb_options caps:ctrl_modifier,caps:escape,altwin:swap_alt_win
    }
  '' # TODO - get model info in home closure. this is thinkpad x240 specific
  }

  input "65261:58893:K.T.E.C._ErgoDone" {
    xkb_layout us
    xkb_variant basic
  }

  input "65261:58893:K.T.E.C._ErgoDone_Keyboard" {
    xkb_layout us
    xkb_variant basic
  }

  # ## Key bindings
  # ### Basics:
  # start a shell
    bindsym $mod+Shift+Return exec ${shellTerm}

  # kill focused window
    bindsym $mod+Shift+c kill

  # start your launcher
    bindsym $mod+Return exec ${launcher}

  # Browser
    bindsym $mod+k exec ${browser}

  # border toggle
    bindsym $mod+shift+b border toggle

  # Drag floating windows by holding down $mod and left mouse button.
  # Resize them with right mouse button + $mod.
  # Despite the name, also works for non-floating windows.
  # Change normal to inverse to use left mouse button for resizing and right
  # mouse button for dragging.
    floating_modifier $mod normal

  # reload the configuration file
    bindsym $mod+q reload

  # exit sway (logs you out of your wayland session)
    bindsym $mod+Shift+q exit

  # Lock
    bindsym $mod+Shift+l exec ${swaylockEksek} --color 000000

  # ### Moving around:
  # Move your focus around
    bindsym $mod+$left focus left
    bindsym $mod+$down focus down
    bindsym $mod+$up focus up
    bindsym $mod+$right focus right
  # or use $mod+[up|down|left|right]
    bindsym $mod+Left focus left
    bindsym $mod+Down focus down
    bindsym $mod+Up focus up
    bindsym $mod+Right focus right

  # _move_ the focused window with the same, but add Shift
    bindsym $mod+Shift+$left move left
    bindsym $mod+Shift+$down move down
    bindsym $mod+Shift+$up move up
    bindsym $mod+Shift+$right move right
  # ditto, with arrow keys
    bindsym $mod+Shift+Left move left
    bindsym $mod+Shift+Down move down
    bindsym $mod+Shift+Up move up
    bindsym $mod+Shift+Right move right

  # ### Workspaces:
    bindsym $mod+a workspace prev
    bindsym $mod+o workspace next
  # switch to workspace
    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace 10
  # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bindsym $mod+Shift+6 move container to workspace 6
    bindsym $mod+Shift+7 move container to workspace 7
    bindsym $mod+Shift+8 move container to workspace 8
    bindsym $mod+Shift+9 move container to workspace 9
    bindsym $mod+Shift+0 move container to workspace 10
  # Note: workspaces can have any name you want, not just numbers.
  # We just use 1-10 as the default.

  # ### Layout stuff:
  # You can "split" the current object of your focus with
  # $mod+b or $mod+v, for horizontal and vertical splits
  # respectively.
    bindsym $mod+b splith
    bindsym $mod+v splitv

  # Switch the current container between different layout styles
    bindsym $mod+g layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+f layout toggle split

  # Make the current focus fullscreen
    bindsym $mod+t fullscreen

  # Toggle the current focus between tiling and floating mode
    bindsym $mod+Shift+space floating toggle

  # Swap focus between the tiling area and the floating area
    bindsym $mod+Ctrl+space focus mode_toggle

  # move focus to the parent container
    bindsym $mod+s focus parent

  # Put on all workspaces; make sticky
    bindsym $mod+z sticky toggle

  # ### Scratchpad:
  # Sway has a "scratchpad", which is a bag of holding for windows.
  # You can send windows there and get them back later.

  # Move the currently focused window to the scratchpad
    bindsym $mod+Shift+minus move scratchpad

  # Show the next scratchpad window or hide the focused scratchpad window.
  # If there are multiple scratchpad windows, this command cycles through them.
    bindsym $mod+minus scratchpad show

  # ### Resizing containers:
    mode "resize" {
      # left will shrink the containers width
      # right will grow the containers width
      # up will shrink the containers height
      # down will grow the containers height
      bindsym $left resize shrink width 10 px or 10 ppt
      bindsym $down resize grow height 10 px or 10 ppt
      bindsym $up resize shrink height 10 px or 10 ppt
      bindsym $right resize grow width 10 px or 10 ppt

      # ditto, with arrow keys
      bindsym Left resize shrink width 10 px or 10 ppt
      bindsym Down resize grow height 10 px or 10 ppt
      bindsym Up resize shrink height 10 px or 10 ppt
      bindsym Right resize grow width 10 px or 10 ppt

      # return to default mode
      bindsym Return mode "default"
      bindsym Escape mode "default"
    }

    bindsym $mod+r mode "resize"

  # ## Status Bar:
  # Read `man 5 sway-bar` for more information about this section.
    bar {
      swaybar_command ${waybarEksek}
    }
''
