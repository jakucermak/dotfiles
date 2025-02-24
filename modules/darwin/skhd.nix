{ pkgs, ... }: {
  home.packages = [ pkgs.skhd ];

  home.file.skhdrc = {
    text = ''
      # focus window
        alt - h : ${pkgs.yabai}/bin/yabai -m window --focus west
        alt - j : ${pkgs.yabai}/bin/yabai -m window --focus south
        alt - k : ${pkgs.yabai}/bin/yabai -m window --focus north
        alt - l : ${pkgs.yabai}/bin/yabai -m window --focus east

        shift + alt - p : ${pkgs.yabai}/bin/yabai -m window --focus stack.prev
        shift + alt - n : ${pkgs.yabai}/bin/yabai -m window --focus stack.next

        shift + alt - p : ${pkgs.yabai}/bin/yabai -m window --focus prev
        shift + alt - n : ${pkgs.yabai}/bin/yabai -m window --focus next

      # swap managed window
      # shift + alt - h : yabai -m window --swap north

      # move managed window
       shift + alt - h : yabai -m window --warp west
       shift + alt - j : yabai -m window --warp north
       shift + alt - k : yabai -m window --warp south
       shift + alt - l : yabai -m window --warp east

      # fast focus desktop
      # cmd + alt - x : yabai -m space --focus recent
      alt - 1 : ${pkgs.yabai}/bin/yabai -m space --focus 1
      alt - 2 : ${pkgs.yabai}/bin/yabai -m space --focus 2
      alt - 3 : ${pkgs.yabai}/bin/yabai -m space --focus 3
      alt - 4 : ${pkgs.yabai}/bin/yabai -m space --focus 4
      alt - 5 : ${pkgs.yabai}/bin/yabai -m space --focus 5
      alt - 6 : ${pkgs.yabai}/bin/yabai -m space --focus 6
      alt - 7 : ${pkgs.yabai}/bin/yabai -m space --focus 7
      alt - 8 : ${pkgs.yabai}/bin/yabai -m space --focus 8
      alt - 9 : ${pkgs.yabai}/bin/yabai -m space --focus 9

      # send window to desktop and follow focus
      # shift + cmd - z : yabai -m window --space next; yabai -m space --focus next
      shift + alt - 1 : ${pkgs.yabai}/bin/yabai -m window --space  1; ${pkgs.yabai}/bin/yabai -m space --focus 1
      shift + alt - 2 : ${pkgs.yabai}/bin/yabai -m window --space  2; ${pkgs.yabai}/bin/yabai -m space --focus 2
      shift + alt - 3 : ${pkgs.yabai}/bin/yabai -m window --space  3; ${pkgs.yabai}/bin/yabai -m space --focus 3
      shift + alt - 4 : ${pkgs.yabai}/bin/yabai -m window --space  4; ${pkgs.yabai}/bin/yabai -m space --focus 4
      shift + alt - 5 : ${pkgs.yabai}/bin/yabai -m window --space  5; ${pkgs.yabai}/bin/yabai -m space --focus 5
      shift + alt - 6 : ${pkgs.yabai}/bin/yabai -m window --space  6; ${pkgs.yabai}/bin/yabai -m space --focus 6
      shift + alt - 7 : ${pkgs.yabai}/bin/yabai -m window --space  7; ${pkgs.yabai}/bin/yabai -m space --focus 7
      shift + alt - 8 : ${pkgs.yabai}/bin/yabai -m window --space  8; ${pkgs.yabai}/bin/yabai -m space --focus 8
      shift + alt - 9 : ${pkgs.yabai}/bin/yabai -m window --space  9; ${pkgs.yabai}/bin/yabai -m space --focus 9

      # focus monitor
      # ctrl + alt - z  : yabai -m display --focus prev
      # ctrl + alt - 3  : yabai -m display --focus 3


      # send window to monitor and follow focus
      # ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
      # ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1

      # move floating window
      # shift + ctrl - a : yabai -m window --move rel:-20:0
      # shift + ctrl - s : yabai -m window --move rel:0:20

      # increase window size
      alt - 0x18 : ${pkgs.yabai}/bin/yabai -m window --resize left:-20:0
      shift + alt - 0x18 : ${pkgs.yabai}/bin/yabai -m window --resize top:0:-20

      # decrease window size
      alt - 0x1B : ${pkgs.yabai}/bin/yabai -m window --resize left:20:0
      shift + alt - 0x1B : ${pkgs.yabai}/bin/yabai -m window --resize top:0:20

      # set insertion point in focused container
      # ctrl + alt - h : yabai -m window --insert west

      # toggle window zoom
      alt - d : yabai -m window --toggle zoom-parent
      shift + alt - f : yabai -m window --toggle zoom-fullscreen

      # toggle window split type
      alt - e : yabai -m window --toggle split

      # Stack / BSP switch
      alt - 0x2B : ${pkgs.yabai}/bin/yabai -m space --layout stack
      alt - 0x2C : ${pkgs.yabai}/bin/yabai -m space --layout bsp

      # float / unfloat window and center on screen
      # alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

      # toggle sticky(+float), picture-in-picture
      # alt - p : yabai -m window --toggle sticky --toggle pip

      alt - return : open -n /Users/jakubcermak/Applications/Home\ Manager\ Apps/Alacritty.app
    '';
    executable = true;
    target = ".skhdrc";
  };
}
