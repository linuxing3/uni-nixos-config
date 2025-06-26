{pkgs, ...}: {
  programs.lf = {
    enable = true;
    commands = {
      dragon-out = ''
        ''${{
          ${pkgs.xdragon}/bin/xdragon -a -x "$fx"
        }}
      '';
      pager = ''
        ''${{
            if [ -f "$f" ]; then
                $PAGER "$f"
            elif [ -d "$f" ]; then
                tree "$f" | $PAGER
            fi
        }}
      '';
      prev = ''
        ''${{
          ${pkgs.bat}/bin/bat --paging=always "$f"
        }}
      '';
      bookmark-jump = ''
        ''${{
            res="$(cat -- "$LF_BOOKMARK_PATH/$(ls -- "$LF_BOOKMARK_PATH" | fzf)" | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id cd \"$res\""
        }};
      '';
      bookmark-create = ''
        ''${{
            read -r ans
            printf '%s\n' "$PWD" > "$LF_BOOKMARK_PATH/$ans"
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
      toggle-prview = ''
        %{{
           if [ "$lf_preview" = true ]; then
             lf -remote "send $id :set preview false; set ratios 1:5"
           else
             lf -remote "send $id :set preview true; set ratios 1:2:3"
           fi
         }}
      '';
      follow-link = ''
        %{{
              lf -remote "send $id select \"$(readlink -- "$f" | sed 's/\\/\\\\/g;s/"/\\"/g')\""
          }}
      '';
      select-glob = ''
        &{{
              select_glob() {
                  files="$(printf '%s\0' "$@" | sed 's/ /\\ /g;s/\x00/ /g')"
                  lf -remote "send $id :unselect; toggle $files"
              }

              [ "$#" -eq 1 ] || exit

              # enable recursive glob and failglob
              shopt -s globstar failglob

              select_glob $1
         }}
      '';

      z = ''
        %{{
            result="$(zoxide query --exclude "$PWD" "$@" | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id cd \"$result\""
        }}
      '';
      zi = ''
          ''${{
            result="$(zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
            lf -remote "send $id cd \"$result\""
        }}
      '';
      on-cd = ''
        &{{
            zoxide add "$PWD"
        }}
      '';
      toggle_hex_view = ''
        &{{
            # reload is used to clear any previews that have been cached
            if [ "$lf_user_hex_view" != true ]; then
                lf -remote "send $id :set user_hex_view true; reload"
            else
                lf -remote "send $id :set user_hex_view false; reload"
            fi
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

      zp = "toggle-preview";
      zx = "toggle_hex_view";

      gL = "follow-link";
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

    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi

        if [ "$lf_user_hex_view" = true ]; then
            hexdump -C "$file"
        fi

        ${pkgs.pistol}/bin/pistol "$file"

      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
      set previewer ${previewer}/bin/pv.sh
    '';
  };

  programs.pistol.enable = true;
}
