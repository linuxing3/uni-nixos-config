{ pkgs, config, ... }:

{

  programs.lf = {
    enable = true;
    commands = {
      dragon-out = ''
        ''${{
          ${pkgs.xdragon}/bin/xdragon -a -x "$fx"
        }}
      '';
      prev = ''
        ''${{
          ${pkgs.bat}/bin/bat --paging=always "$f"
        }}
      '';
      bulk-rename = ''
        ''${{
        old="$(mktemp)"
        new="$(mktemp)"
        if [ -n "$fs" ]; then
            fs="$(basename -a -- $fs)"
        else
            fs="$(ls)"
        fi
        printf '%s\n' "$fs" > "$old"
        printf '%s\n' "$fs" > "$new"
        $EDITOR "$new"
        [ "$(wc -l < "$new")" -ne "$(wc -l < "$old")" ] && exit
        paste "$old" "$new" | while IFS= read -r names; do
            src="$(printf '%s' "$names" | cut -f1)"
            dst="$(printf '%s' "$names" | cut -f2)"
            if [ "$src" = "$dst" ] || [ -e "$dst" ]; then
                continue
            fi
            mv -- "$src" "$dst"
        done
        rm -- "$old" "$new"
        lf -remote "send $id unselect"
        }}
      '';
      mkfile = ''
        ''${{
          printf "File Name: "
          read FILENAME
          touch $FILENAME
        }}
      '';
      mkdir = ''
        ''${{
          printf "Directory Name: "
          read DIR
          mkdir $DIR
        }}
      '';
    };

    keybindings = {

      "\\\"" = "";
      b = "bulk-rename";
      c = "mkdir";
      a = "mkfile";
      x = ''%rm "$fx"'';
      X = ''%rm -rf "$fx"'';
      "." = "set hidden!";
      "`" = "mark-load";
      "\\'" = "mark-load";
      "<enter>" = "open";

      do = "dragon-out";

      "g~" = "cd";
      gh = "cd";
      "g/" = "/";

      V = "prev";

      # ...
    };

    settings = {
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig =
      let
        previewer =
          pkgs.writeShellScriptBin "pv.sh" ''
            file=$1
            w=$2
            h=$3
            x=$4
            y=$5
        
            if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
                ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
                exit 1
            fi
        
            ${pkgs.pistol}/bin/pistol "$file"
          '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in
      ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
  };

  programs.pistol.enable = true;


}
