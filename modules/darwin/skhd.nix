{ pkgs, ... }: {
  home.packages = [ pkgs.skhd ];

  home.file.skhdrc = {
    text = ''
      # focus window
      alt - h : /opt/homebrew/bin/yabai -m window --focus west
      alt - j : /opt/homebrew/bin/yabai -m window --focus south
      alt - k : /opt/homebrew/bin/yabai -m window --focus north
      alt - l : /opt/homebrew/bin/yabai -m window --focus east

      shift + alt - p : /opt/homebrew/bin/yabai -m window --focus stack.prev
      shift + alt - n : /opt/homebrew/bin/yabai -m window --focus stack.next

      shift + alt - p : /opt/homebrew/bin/yabai -m window --focus prev
      shift + alt - n : /opt/homebrew/bin/yabai -m window --focus next
      shift + alt - c : /opt/homebrew/bin/yabai -m window --lower; /opt/homebrew/bin/yabai -m query --spaces | jq -re '.[] | select(."is-visible"== true).index' | xargs -I{} /opt/homebrew/bin/yabai -m query --windows --space {} | jq -sre 'add | sort_by(.display, .frame.x, .frame.y, .id) | nth(index(map(select(."has-focus" == true))) - 1).id' | xargs -I{} /opt/homebrew/bin/yabai -m window --focus {}
      alt - c : /opt/homebrew/bin/yabai -m window --raise; /opt/homebrew/bin/yabai -m query --spaces | jq -re '.[] | select(."is-visible"== true).index' | xargs -I{} /opt/homebrew/bin/yabai -m query --windows --space {} | jq -sre 'add | sort_by(.display, .frame.x, .frame.y, .id) | nth(index(map(select(."has-focus" == true))) - 1).id' | xargs -I{} /opt/homebrew/bin/yabai -m window --focus {}


      # swap managed window
      # shift + alt - h : /opt/homebrew/bin/yabai -m window --swap north

      # move managed window
      shift + alt - h : /opt/homebrew/bin/yabai -m window --warp west
      shift + alt - j : /opt/homebrew/bin/yabai -m window --warp north
      shift + alt - k : /opt/homebrew/bin/yabai -m window --warp south
      shift + alt - l : /opt/homebrew/bin/yabai -m window --warp east

      # fast focus desktop
      # cmd + alt - x : /opt/homebrew/bin/yabai -m space --focus recent
      alt - 1 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 1 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 1
      alt - 2 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 2 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 2
      alt - 3 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 3 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 3
      alt - 4 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 4 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 4
      alt - 5 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 5 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 5
      alt - 6 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 6 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 6
      alt - 7 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 7 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 7
      alt - 8 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 8 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 8
      alt - 9 : /opt/homebrew/bin/yabai -m window --focus $(/opt/homebrew/bin/yabai -m query --windows --space 9 | jq 'if .[0]."is-sticky" == "false" then .[0] else .[1] end') || /opt/homebrew/bin/yabai -m space --focus 9

      # send window to desktop and follow focus
      # shift + cmd - z : /opt/homebrew/bin/yabai -m window --space next; /opt/homebrew/bin/yabai -m space --focus next
      shift + alt - 1 : /opt/homebrew/bin/yabai -m window --space  1; /opt/homebrew/bin/yabai -m space --focus 1
      shift + alt - 2 : /opt/homebrew/bin/yabai -m window --space  2; /opt/homebrew/bin/yabai -m space --focus 2
      shift + alt - 3 : /opt/homebrew/bin/yabai -m window --space  3; /opt/homebrew/bin/yabai -m space --focus 3
      shift + alt - 4 : /opt/homebrew/bin/yabai -m window --space  4; /opt/homebrew/bin/yabai -m space --focus 4
      shift + alt - 5 : /opt/homebrew/bin/yabai -m window --space  5; /opt/homebrew/bin/yabai -m space --focus 5
      shift + alt - 6 : /opt/homebrew/bin/yabai -m window --space  6; /opt/homebrew/bin/yabai -m space --focus 6
      shift + alt - 7 : /opt/homebrew/bin/yabai -m window --space  7; /opt/homebrew/bin/yabai -m space --focus 7
      shift + alt - 8 : /opt/homebrew/bin/yabai -m window --space  8; /opt/homebrew/bin/yabai -m space --focus 8
      shift + alt - 9 : /opt/homebrew/bin/yabai -m window --space  9; /opt/homebrew/bin/yabai -m space --focus 9

      # focus monitor
      # ctrl + alt - z  : /opt/homebrew/bin/yabai -m display --focus prev
      # ctrl + alt - 3  : /opt/homebrew/bin/yabai -m display --focus 3


      # send window to monitor and follow focus
      # ctrl + cmd - c  : /opt/homebrew/bin/yabai -m window --display next; /opt/homebrew/bin/yabai -m display --focus next
      # ctrl + cmd - 1  : /opt/homebrew/bin/yabai -m window --display 1; /opt/homebrew/bin/yabai -m display --focus 1

      # move floating window
      # shift + ctrl - a : /opt/homebrew/bin/yabai -m window --move rel:-20:0
      # shift + ctrl - s : /opt/homebrew/bin/yabai -m window --move rel:0:20

      # increase window size
      alt - 0x18 : /opt/homebrew/bin/yabai -m window --resize left:-20:0
      shift + alt - 0x18 : /opt/homebrew/bin/yabai -m window --resize top:0:-20

      # decrease window size
      alt - 0x1B : /opt/homebrew/bin/yabai -m window --resize left:20:0
      shift + alt - 0x1B : /opt/homebrew/bin/yabai -m window --resize top:0:20

      # set insertion point in focused container
      # ctrl + alt - h : /opt/homebrew/bin/yabai -m window --insert west

      # toggle window zoom
      alt - d : /opt/homebrew/bin/yabai -m window --toggle zoom-parent
      shift + alt - f : /opt/homebrew/bin/yabai -m window --toggle zoom-fullscreen

      # toggle window split type
      alt - e : /opt/homebrew/bin/yabai -m window --toggle split

      # Stack / BSP switch
      alt - 0x2B : /opt/homebrew/bin/yabai -m space --layout stack
      alt - 0x2C : /opt/homebrew/bin/yabai -m space --layout bsp

      # float / unfloat window and center on screen
      alt - t : /opt/homebrew/bin/yabai -m window --toggle float --grid 20:20:2:2:16:16

      # toggle sticky(+float), picture-in-picture
      # alt - p : /opt/homebrew/bin//opt/homebrew/bin/yabai -m window --toggle sticky --toggle pip

      alt - return : ~/.config/skhd_scripts/ghostty_float
    '';
    executable = true;
    target = ".skhdrc";
  };
  home.file.".config/skhd_scripts".source = ./skhd_scripts;
  home.file.".config/skhd_scripts/ghostty_float".executable = true;
  home.file.".config/skhd_scripts/ghostty_float".source =
    ./skhd_scripts/ghostty_float;
}
