{ kor, pkgs, krimyn, profile, config, ... }:
let
  inherit (builtins) readFile toString;
  inherit (kor) mkIf optionalString;
  inherit (krimyn.spinyrz) iuzColemak;
  inherit (profile) dark;

  whitelist = [
    "https://duckduckgo.com"
    "https://github.com"
    "https://gitlab.com"
    "https://bitbucket.org"
    "https://gitlab.gnome.org"
    "https://gitlab.redox-os.org"
    "https://gitlab.freedesktop.org"
    "https://gitlab.e.foundation/e/apps"
    "https://gitea.com"
    "https://codeberg.org"
    "https://source.puri.sm"
    "https://crates.io"
    "https://docs.rs"
    "https://doc.rust-lang.org"
    "https://rustc-dev-guide.rust-lang.org"
    "https://rust-lang.github.io/async-book"
    "https://hydra.nixos.org"
    "https://admin.gandi.net"
    "https://cloud.linode.com"
    "https://login.linode.com"
    "https://mail.protonmail.com"
    "https://login.protonmail.com"
    "https://www.cloudflare.com"
    "https://dash.cloudflare.com"
    "https://download.lineageos.org"
    "https://opengapps.org"
    "https://postmarketos.org"
    "https://asciinema.org"
    "https://www.reddit.com"
    "https://www.goodreads.com"
    "https://www.allmusic.com"
    "https://www.imdb.com"
  ];

  mkDomainString = domain:
    "config.set('content.javascript.enabled', True, '${domain}/*')";
  mkDomainsList = map (domain: mkDomainString domain) whitelist;
  domainListBlok = builtins.concatStringsSep "\n" mkDomainsList;

in
{
  home = {
    packages = [ pkgs.qutebrowser ];

    file = {
      ".config/qutebrowser/config.py".text = ''
        config.load_autoconfig(False)
        c.qt.force_platform = "wayland"
        # General configurations
        c.downloads.remove_finished = 2000
        c.completion.delay = 200
        c.completion.web_history.max_items = 5000
        c.completion.web_history.exclude = [
          "https://google.com/"
          "https://duckduckgo.com/"
          "https://startpage.com/"
          "https://github.com/"
        ]

        c.scrolling.smooth = True
        c.scrolling.bar = "never"
        c.colors.webpage.darkmode.enabled = ${if dark then "True" else "False"}
        c.fonts.web.size.default = 18

        config.set('content.javascript.enabled', False)
        config.set('content.javascript.enabled', True, 'http://[::1]*')

        config.set('content.javascript.enabled', True, 'file://${config.home.homeDirectory}/html/*')

        ${domainListBlok}

        c.url.start_pages = ["qute://history/"]

        c.url.searchengines = {
        "DEFAULT": "https://duckduckgo.com/?q={}",
        "g": "https://google.com/search?hl=en&q={}",
        "s": "https://www.startpage.com/do/dsearch?query={}",
        "sx": "https://searx.me/?q={}",
        "d": "https://duckduckgo.com/?q={}",
        "cb": "https://codeberg.org/explore/repos?tab=&sort=recentupdate&q={}",
        "gl": "https://gitlab.com/search?utf8=%E2%9C%93&search={}",
        "gh": "https://github.com/search?utf8=/&q={}",
        "gist": "https://gist.github.com/search?utf8=%E2%9C%93&q={}",
        "ghr": "https://github.com/search?utf8=/&q={}%20language%3Arust",
        "ghqtb": "https://github.com/qutebrowser/qutebrowser/search?q={}&type=Issues",
        "ghpkgs": "https://github.com/NixOS/nixpkgs/search?q={}&type=Issues",
        "ghnix": "https://github.com/NixOS/nix/search?q={}&type=Issues",
        "ghhome": "https://github.com/rycee/home-manager/search?q={}&type=Issues",
        "ghvim": "https://github.com/neovim/neovim/search?q={}&type=Issues",
        "ghsway": "https://github.com/swaywm/sway/search?q={}&type=Issues",
        "librs": "https://lib.rs/search?q={}",
        "aw": "https://wiki.archlinux.org/?search={}",
        "gw": "https://wiki.gentoo.org/index.php?title=Special%3ASearch&search={}",
        "alw": "https://wiki.alpinelinux.org/w/index.php?title=Special%3ASearch&profile=default&search={}",
        "so": "https://stackoverflow.com/search?q={}",
        "w": "http://en.wikipedia.org/w/index.php?title=Special:Search&search={}",
        "yt": "https://www.youtube.com/results?search_query={}",
        "leet": "https://1337x.to/torrent/search/{}/1/",
        "gr": "https://www.goodreads.com/search?q={}",
        }

        c.bindings.commands["normal"] = {
          # User bindings
          "<Ctrl-M>": "spawn mpv --ytdl-format=webm {url}",
          ";m": "hint links spawn mpv --ytdl-format=webm {hint-url}",
          "<Ctrl-R>": "config-source ",
          "<Ctrl-E>": "set-cmd-text -s :buffer ",
          "zu": 'spawn --userscript qute-pass --username-target secret --username-pattern "login: (.+)" --dmenu-invocation "wofi --show dmenu"',
          'znu': 'spawn --userscript qute-pass --username-target secret --username-pattern "login: (.+)" --dmenu-invocation "wofi --show dmenu" --username-only',
          'ztu': 'spawn --userscript qute-pass  --dmenu-invocation "wofi --show dmenu" --password-only',
          'zou': 'spawn --userscript qute-pass  --dmenu-invocation "wofi --show dmenu" --otp-only',
      '' + (optionalString iuzColemak ''
        # Indentation hak
          ";G": "hint images tab",
          ";Y": "hint links fill :open -t -r {hint-url}",
          ";P": "hint --rapid links window",
          ";J": "hint links yank-primary",
          ";s": "hint links download",
          ";t": "hint all tab-fg",
          ";g": "hint images",
          ";y": "hint links fill :open {hint-url}",
          ";p": "hint --rapid links tab-bg",
          ";u": "hint inputs",
          ";j": "hint links yank",
          "<Ctrl-S>": "scroll-page 0 0.5",
          "<Ctrl-T>": "scroll-page 0 1",
          "<Ctrl-K>": "open -w",
          "<Ctrl-Shift-K>": "open -p",
          "<Ctrl-Shift-G>": "undo",
          "<Ctrl-G>": "open -t",
          "<Ctrl-L>": "scroll-page 0 -0.5",
          "<Ctrl-o>": "tab-pin",
          "<Ctrl-r>": "stop",
          "S": "tab-close -o",
          "T": "hint all tab",
          "G": "scroll-to-perc",
          "N": "tab-next",
          "E": "tab-prev",
          "I": "forward",
          "K": "search-prev",
          "Y": "set-cmd-text -s :open -t",
          "O": "", # unbind
          "OO": "open -t -- {primary}",
          "Oo": "open -t -- {clipboard}",
          "P": "reload -f",
          "Rb": "open qute://bookmarks#bookmarks",
          "Rh": "open qute://history",
          "Rq": "open qute://bookmarks",
          "Rr": "open qute://settings",
          "G": "tab-focus",
          "D": "scroll-to-perc 100",
          "as": "download-cancel",
          "cs": "download-clear",
          "cy": "tab-only",
          "s": "tab-close",
          "t": "hint",
          "d": "",  # Needed to unbind
          "d$": "tab-focus -1",
          "d0": "tab-focus 1",
          "dB": "set-cmd-text -s :bookmark-load -t",
          "dC": "tab-clone",
          "dY": "set-cmd-text :open -t -r {url:pretty}",
          "dL": "navigate up -t",
          "d^": "tab-focus 1",
          "da": "open -t",
          "db": "set-cmd-text -s :bookmark-load",
          "ds": "download",
          "dt": "view-source",
          "dd": "scroll-to-perc 0",
          "du": "hint inputs --first",
          "di": "tab-move -",
          "dm": "tab-move",
          "dy": "set-cmd-text :open {url:pretty}",
          "dp": "tab-move +",
          "dg": "set-cmd-text -s :buffer",
          "dl": "navigate up",
          "u": "enter-mode insert",
          "n": "scroll down",
          "e": "scroll up",
          "i": "scroll right",
          "k": "search-next",
          "y": "set-cmd-text -s :open",
          "o": "",
          "oO": "open -- {primary}",
          "oo": "open -- {clipboard}",
          "p": "reload",
          "rt": "save",
          "re": "set-cmd-text -s :bind",
          "ri": "set-cmd-text -s :set -t",
          "rr": "set-cmd-text -s :set",
          "gOH": "config-cycle -p -u *://*.{url:host}/* content.plugins ;; reload",
          "gOh": "config-cycle -p -u *://{url:host}/* content.plugins ;; reload",
          "gOl": "config-cycle -p -u {url} content.plugins ;; reload",
          "gRH": "config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload",
          "gRh": "config-cycle -p -u *://{url:host}/* content.javascript.enabled ;; reload",
          "gRu": "config-cycle -p -u {url} content.javascript.enabled ;; reload",
          "gh": "back -t",
          "gi": "forward -t",
          "goH": "config-cycle -p -t -u *://*.{url:host}/* content.plugins ;; reload",
          "goh": "config-cycle -p -t -u *://{url:host}/* content.plugins ;; reload",
          "gol": "config-cycle -p -t -u {url} content.plugins ;; reload",
          "grH": "config-cycle -p -t -u *://*.{url:host}/* content.javascript.enabled ;; reload",
          "grh": "config-cycle -p -t -u *://{url:host}/* content.javascript.enabled ;; reload",
          "grl": "config-cycle -p -t -u {url} content.javascript.enabled ;; reload",
          "l": "undo",
          "wY": "set-cmd-text :open -w {url:pretty}",
          "wO": "open -w -- {primary}",
          "wt": "hint all window",
          "wu": "inspector",
          "wi": "forward -w",
          "wy": "set-cmd-text -s :open -w",
          "wo": "open -w -- {clipboard}",
          "xY": "set-cmd-text :open -b -r {url:pretty}",
          "xy": "set-cmd-text -s :open -b",
          "j": "",
          "jS": "yank domain -s",
          "jO": "yank pretty-url -s",
          "jG": "yank title -s",
          "jJ": "yank -s",
          "js": "yank domain",
          "jo": "yank pretty-url",
          "jg": "yank title",
          "jj": "yank",
      '') + ''
        }
      '' + (optionalString iuzColemak ''
        c.hints.chars = "arstdhneio"
        c.bindings.commands["caret"] = {
          "D": "move-to-end-of-document",
          "N": "scroll down",
          "E": "scroll up",
          "I": "scroll right",
          "J": "yank selection -s",
          "f": "move-to-end-of-word",
          "dd": "move-to-start-of-document",
          "n": "move-to-next-line",
          "e": "move-to-prev-line",
          "i": "move-to-next-char",
          "j": "yank selection",
        }
        c.bindings.commands["command"] = {
          "<Alt-S>": "rl-kill-word",
          "<Alt-T>": "rl-forward-word",
          "<Ctrl-S>": "completion-item-del",
          "<Ctrl-F>": "rl-end-of-line",
          "<Ctrl-T>": "rl-forward-char",
          "<Ctrl-E>": "rl-kill-line",
          "<Ctrl-K>": "command-history-next",
          "<Ctrl-O>": "command-history-prev",
          "<Ctrl-L>": "rl-unix-line-discard",
          "<Ctrl-J>": "rl-yank",
        }
        c.bindings.commands["hint"] = {
          "<Ctrl-T>": "hint links",
          "<Ctrl-P>": "hint --rapid links tab-bg",
        }
        c.bindings.commands["insert"] = {
          "<Ctrl-F>": "open-editor",
        }
      '');

    };

  };
}
