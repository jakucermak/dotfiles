{ ... }: {

  home.file.".config/sketchybar".source = ./config;

  home.file.".config/sketchybar/sketchybarrc".executable = true;
  home.file.".config/sketchybar/sketchybarrc".source = ./config/sketchybarrc;

}
