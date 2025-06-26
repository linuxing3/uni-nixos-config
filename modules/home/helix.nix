{
  pkgs,
  config,
  ...
}: let
  # path to your helix config directory
  helixPath = "/persistent/home/linuxing3/.config/helix";
in {
  xdg.configFile."helix".source = config.lib.file.mkOutOfStoreSymlink helixPath;

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      marksman
      markdown-oxide
      markdownlint-cli

      helix-gpt
      # dot-dot-language-server
      # jq-lsp
      # bash-language-server
      # protobuf
      # svelte-language-server
      # wgsl-analyzer
      # nimlangserver
      # ruff
      # superhtml
      # vue-language-server
      # dockerfile-language-server-nodejs
      # cmake-language-server
      # texlab
      # lua-language-server
    ];

    # User settings
    # settings = {
    #   theme = "base16_transparent";
    #   editor = {
    #     line-number = "relative";
    #     mouse = true;
    #     middle-click-paste = true;
    #     cursorline = true;
    #     cursorcolumn = false;
    #     cursor-shape = {
    #       insert = "bar";
    #       normal = "block";
    #       select = "underline";
    #     };
    #     statusline = {
    #       left = [
    #         "mode"
    #         "spinner"
    #       ];
    #       center = ["file-name"];
    #       right = [
    #         "diagnostics"
    #         "selections"
    #         "position"
    #         "file-encoding"
    #         "file-line-ending"
    #         "file-type"
    #       ];
    #       separator = "│";
    #       mode.normal = "NORMAL";
    #       mode.insert = "INSERT";
    #       mode.select = "SELECT";
    #     };
    #   };
    #   keys.insert = {
    #     F1 = [":format" ":w!"];
    #     F2 = ["rename_symbol" ":w!"];
    #     F3 = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
    #     F4 = [":new" ":insert-output lfpick" "split_selection_on_newline" "goto_file" ":bco!" ":redraw"];
    #     F5 = [":pipe-to kitty just build"];
    #     F6 = [":pipe-to kitty just run"];
    #     F7 = ["dap_launch"];
    #     F8 = ["dap_continue"];
    #     F9 = ["dap_step_in"];
    #     F10 = ["dap_step_out"];
    #     F11 = ["goto_definition"];
    #     F12 = ["goto_implementation"];

    #     j = {
    #       j = ["normal_mode" ":w!"];
    #     };

    #     "C-c" = ["toggle_comments" ":w!"];

    #     "C-a" = "insert_at_line_start";
    #     "C-e" = "insert_at_line_end";
    #     "C-j" = "kill_to_line_start";
    #     "C-k" = "kill_to_line_end";

    #     "C-," = ["normal_mode" "move_prev_word_start" "move_next_word_end" "search_selection_detect_word_boundaries" "select_mode"];
    #     "C-." = ["normal_mode" "move_prev_word_start" "move_next_word_end" "search_selection_detect_word_boundaries"];
    #     "C-/" = ["normal_mode" "move_prev_word_start" "move_next_word_end" "search_selection_detect_word_boundaries" "select_mode" "global_search"];

    #     "S-A-up" = ["move_visual_line_up" "extend_line_below" "delete_selection" "paste_after" "collapse_selection" "move_visual_line_up"];
    #     "S-A-down" = ["extend_line_below" "delete_selection" "paste_after" "collapse_selection"];

    #     "C-d" = ["extend_line_below" "yank" "paste_after" "collapse_selection" ":w!"];
    #   };
    #   keys.normal = {
    #     F1 = [":format" ":w!"];
    #     F2 = ["rename_symbol" ":w!"];
    #     F3 = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw"];
    #     F4 = [":new" ":insert-output lf-pick" "split_selection_on_newline" "goto_file" ":buffer-close!" ":redraw"];
    #     F5 = [":pipe-to kitty just build"];
    #     F6 = [":pipe-to kitty just run"];
    #     F7 = "dap_launch";
    #     F8 = "dap_continue";
    #     F9 = "dap_step_in";
    #     F10 = "dap_step_out";
    #     F11 = "goto_definition";
    #     F12 = "goto_implementation";

    #     space = {
    #       space = "command_mode";
    #       ":" = "command_mode";
    #       "." = "file_picker_in_current_directory";
    #       "," = ":bco!";
    #       f = "file_picker";
    #       v = ":vnew";
    #       n = ":new";
    #       q = ":bc!";
    #       x = ":wa!";
    #       z = ":xa!";
    #     };

    #     "C-p" = {
    #       a = [":cd ~/sources/uni-nixos-config"];
    #       i = [":cd ~/sources/linuxing3-nixos-config"];
    #       b = [":cd ~/sources/nixpkgs"];
    #       c = [":cd ~/sources/home-manager"];
    #       d = [":cd ~/sources/nix-templates"];
    #       e = [":cd ~/sources/dev-templates"];
    #       f = [":cd ~/sources/devbox"];
    #       g = [":cd ~/.config/emacs"];
    #       h = [":cd ~/.config/doom"];
    #     };

    #     "+" = {
    #       "+" = ":theme";
    #       a = ":theme gruvbox_dark_hard";
    #       b = ":theme gruvbox_light_hard";
    #       c = ":theme base16_default_dark";
    #       d = ":theme base16_default_light";
    #       e = ":theme ayu_light";
    #       f = ":theme ayu_dark";
    #       g = ":theme github_light";
    #       h = ":theme github_dark";
    #       i = ":theme onedark";
    #       j = ":theme onelight";
    #       k = ":theme tokyonight_day";
    #       l = ":theme tokyonight_moon";
    #       m = ":theme rose_pine_dawn";
    #       n = ":theme rose_pine_moon";
    #     };

    #     "=" = {
    #       "1" = ":pipe-to kitty nh os switch";
    #       "2" = ":pipe-to kitty nh os build";
    #       "3" = ":pipe-to kitty nh home switch";
    #       "4" = ":pipe-to kitty nh home build";
    #       a = ":pipe-to kitty cmake -B build -S . -DCMAKE_EXPORT_COMPILE_COMMANDS=1";
    #       b = ":pipe-to kitty cmake --build build";
    #       e = ":pipe-to kitty emacsclient -r -nw";
    #       h = ":pipe-to kitty ssh hw";
    #       k = ":pipe-to kitty ssh hwx";
    #       m = ":pipe-to kitty xmake";
    #       r = ":pipe-to kitty xmake run";
    #       s = ":pipe-to kitty xmake project -k compile_commands";
    #       c = ":pipe-to kitty cargo build";
    #       g = ":pipe-to kitty cargo run";
    #       t = ":pipe-to kitty cargo test";
    #       p = ":pipe-to kitty pixi run start";
    #       u = ":pipe-to kitty plantuml -tsvg *.puml";
    #       x = ":pipe-to kitty hx";
    #       y = ":pipe-to kitty yazi";
    #       z = ":pipe-to kitty emacsclient -r -nw";
    #     };

    #     "C-," = ["move_prev_word_start" "move_next_word_end" "search_selection_detect_word_boundaries" "select_mode"];
    #     "C-." = ["move_prev_word_start" "move_next_word_end" "search_selection_detect_word_boundaries"];
    #     "C-/" = ["move_prev_word_start" "move_next_word_end" "search_selection_detect_word_boundaries" "select_mode" "global_search"];

    #     "$" = ["split_selection_on_newline" "insert_at_line_end" "normal_mode"];
    #     "0" = ["split_selection_on_newline" "insert_at_line_start" "normal_mode"];

    #     "S-A-up" = ["move_visual_line_up" "extend_line_below" "delete_selection" "paste_after" "collapse_selection" "move_visual_line_up"];
    #     "S-A-down" = ["extend_line_below" "delete_selection" "paste_after" "collapse_selection"];

    #     "C-d" = ["extend_line_below" "yank" "paste_after" "collapse_selection"];

    #     U = "kill_to_line_start";
    #     D = "kill_to_line_end";

    #     "C-c" = ["toggle_comments" ":w!"];

    #     H = ":bp";
    #     L = ":bn";

    #     G = "goto_last_line";
    #     esc = ["collapse_selection" "keep_primary_selection"];

    #     g = {
    #       c = "toggle_comments";
    #     };
    #   };
    # };
    # Languages
    # languages = {
    #   # language
    #   language = [
    #     # typescript
    #     {
    #       name = "typescript";
    #       roots = [
    #         "deno.json"
    #         "deno.jsonc"
    #         "package.json"
    #       ];
    #       auto-format = true;
    #       language-servers = ["deno-lsp" "gpt"];
    #     }
    #     # javascript
    #     {
    #       name = "javascript";
    #       roots = [
    #         "deno.json"
    #         "deno.jsonc"
    #         "package.json"
    #       ];
    #       auto-format = true;
    #       language-servers = ["deno-lsp" "gpt"];
    #     }
    #     # java
    #     {
    #       name = "java";
    #       scope = "source.java";
    #       injection-regex = "java";
    #       file-types = [
    #         "java"
    #         "jav"
    #         "pde"
    #       ];
    #       roots = [
    #         "pom.xml"
    #         "build.gradle"
    #         "build.gradle.kts"
    #       ];
    #       language-servers = ["jdtls" "gpt"];
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };
    #       comment-tokens = ["//"];
    #       block-comment-tokens = {
    #         start = "/*";
    #         end = "*/";
    #       };

    #       # grammar = {
    #       #   name = "java";
    #       #   source = {
    #       #     git = "https://github.com/tree-sitter/tree-sitter-java";
    #       #     rev = "09d650def6cdf7f479f4b78f595e9ef5b58ce31e";
    #       #   };
    #       # };
    #     }
    #     # rust
    #     {
    #       name = "rust";
    #       auto-format = false;
    #     }
    #     # zig
    #     {
    #       name = "zig";
    #       scope = "source.zig";
    #       injection-regex = "zig";
    #       file-types = [
    #         "zig"
    #         "zon"
    #       ];
    #       roots = ["build.zig"];
    #       auto-format = true;
    #       comment-tokens = [
    #         "//"
    #         "///"
    #         "//!"
    #       ];
    #       language-servers = ["zls" "gpt"];
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };
    #       formatter = {
    #         command = "zig";
    #         args = [
    #           "fmt"
    #           "--stdin"
    #         ];
    #       };
    #       # grammar = {
    #       #   name = "zig";
    #       #   source = {
    #       #     git = "https://github.com/tree-sitter-grammars/tree-sitter-zig";
    #       #     rev = "eb7d58c2dc4fbeea4745019dee8df013034ae66b";
    #       #   };
    #       # };
    #     }
    #     # nix
    #     {
    #       name = "nix";
    #       scope = "source.nix";
    #       injection-regex = "nix";
    #       file-types = ["nix"];
    #       shebangs = [];
    #       auto-format = true;
    #       comment-token = "#";
    #       language-servers = [
    #         "nil"
    #         "nixd"
    #         "gpt"
    #       ];
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };
    #       formatter = {
    #         command = "alejandra";
    #         args = [
    #           "--quiet"
    #           "--"
    #         ];
    #       };
    #     }
    #     {
    #       name = "json";
    #       scope = "source.json";
    #       injection-regex = "json";
    #       file-types = [
    #         "json"
    #         "jsonc"
    #         "arb"
    #         "ipynb"
    #         "geojson"
    #         " gltf"
    #         "webmanifest"
    #         {glob = "flake.lock";}
    #         {glob = ".babelrc";}
    #         {glob = ".bowerrc";}
    #         {glob = ".jscrc";}
    #         "js.map"
    #         "ts.map"
    #         "css.map"
    #         {glob = ".jslintrc";}
    #         "jsonl"
    #         "jsonld"
    #         {glob = ".vuerc";}
    #         {glob = "composer.lock";}
    #         {glob = ".watchmanconfig";}
    #         "avsc"
    #         "ldtk"
    #         "ldtkl"
    #         {glob = ".swift-format";}
    #       ];
    #     }
    #     {
    #       name = "html";
    #       scope = "text.html.basic";
    #       injection-regex = "html";
    #       file-types = [
    #         "html"
    #         "htm"
    #         "shtml"
    #         "xhtml"
    #         "xht"
    #         "jsp"
    #         "asp"
    #         "aspx"
    #         "jshtm"
    #         "volt"
    #         "rhtml"
    #         "cshtml"
    #       ];
    #       block-comment-tokens = {
    #         start = "<!--";
    #         end = "-->";
    #       };
    #       auto-format = true;
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };
    #     }
    #   ];

    #   # language-server
    #   language-server = {
    #     # deno
    #     gpt = {
    #       command = "helix-gpt";
    #     };
    #     # deno
    #     deno-lsp = {
    #       command = "deno";
    #       args = ["lsp"];
    #       config.deno.enable = true;
    #     };
    #     # typescript
    #     typescript-language-server = with pkgs.nodePackages; {
    #       command = "${typescript-language-server}/bin/typescript-language-server";
    #       args = [
    #         "--stdio"
    #         "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"
    #       ];
    #     };
    #     # nil
    #     nil = {
    #       command = "nil";
    #       args = ["--stdio"];
    #     };
    #     # json
    #     vscode-json-language-server = {
    #       auto-format = true;
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };
    #     };
    #     # html
    #     vscode-html-language-server = {
    #       auto-format = true;
    #       indent = {
    #         tab-width = 2;
    #         unit = "  ";
    #       };
    #     };
    #   };
    # };

    # ignores = [
    #   "node_modules"
    #   ".local/"
    #   ".config/"
    #   ".build/"
    #   ".direnv/"
    #   "build/"
    #   "result/"
    #   "!.gitignore"
    # ];
  };
}
