{ kor, pkgs, pkdjz, krimyn, config, profile, hyraizyn, ... }:
let
  inherit (builtins) concatStringsSep readFile elem concatMap toJSON;
  inherit (kor) optionalString optionals mkIf mapAttrsToList optional optionalAttrs;
  inherit (krimyn.spinyrz) izUniksDev saizAtList iuzColemak;
  inherit (hyraizyn) astra;
  inherit (profile) dark;
  inherit (pkgs) parinfer-rust writeText;
  inherit (pkdjz) vimPloginz;

  aolPloginz = pkgs.vimPlugins // vimPloginz;

  minVimLPloginz = with vimPloginz; [
    dwm-vim
    vim-visual-multi
    fzf-vim
    zoxide-vim
    astronauta-nvim
    guile-vim
    vim-shen
  ];

  medVimlPlogins = with aolPloginz; [
    vim-parinfer
    nvim-yarp # UpdateRemotePlugin replacement
    gina-vim # git
    vista-vim # Tags
    vim-toml
    ron-vim
    tokei-vim
    vim-nix
    dhall-vim
    vim-markdown
    vim-ledger
    vim-surround
    vim-pager
    vim-rooter
    ultisnips
    vim-snippets
    bufferize-vim
    minimap-vim
    hop-nvim
  ];

  maxVimlPlogins = with aolPloginz; [
    vim-fugitive # git
    gv-vim
  ];

  vimlPloginz = minVimLPloginz
    ++ (optionals saizAtList.med medVimlPlogins)
    ++ (optionals saizAtList.max maxVimlPlogins);

  luaPloginz = minLuaPloginz
    ++ (optionals saizAtList.med medLuaPloginz)
    ++ (optionals saizAtList.max maxLuaPloginz);

  minLuaPloginz = with vimPloginz; [
    plenary-nvim
    popup-nvim
    nvim-tree-lua
    lir-nvim
    completion-nvim
    completion-buffers
    nvim-treesitter
    nvim-treesitter-refactor
    nvim-treesitter-textobjects
    nvim-bufferline-lua
    telescope-nvim
    FTerm-nvim
    neogit # bogi
    gitsigns-nvim # bogi
    BufOnly-nvim
    nvim-autopairs
    nvim-fzf
    nvim-fzf-commands
    kommentary
    express_line-nvim
  ];

  medLuaPloginz = with vimPloginz; [
    nvim-lspconfig
    lsp-status-nvim
    nvim-lspfuzzy
    nvim-web-devicons
    nvim-colorizer-lua
    nvim-base16-lua
    nvim-lazygit
    fzf-lsp-nvim
    formatter-nvim
  ];

  maxLuaPloginz = with vimPloginz; [
    lspsaga-nvim
  ];


  themeKod =
    let
      lightTheme = "google-light";
      darkTheme = "bright";
      theme = if dark then darkTheme else lightTheme;
    in
    ''
      vim.g.syntax_cmd = 'skip'
      local base16 = require 'base16'
      base16(base16.themes['${theme}'], true)
      command('hi def link NeogitDiffAddHighlight SignColumn')
      command('hi def link NeogitDiffDeleteHighlight SignColumn')
      command('hi def link NeogitDiffContextHighlight SignColumn')
      command('hi def link NeogitHunkHeader SignColumn')
      command('hi def link NeogitHunkHeaderHighlight SignColumn')
    '';

  ctagsKod = ''
    vim.g['loaded_gentags#gtags'] = 1
    vim.g['gen_tags#ctags_bin'] = '${pkgs.universal-ctags}/bin/ctags'
  '';

  treeGrammars = pkgs.tree-sitter.builtGrammars;
  treesitterParserz = ''
    vim.treesitter.require_language("rust", [[${treeGrammars.tree-sitter-rust}/parser]])
  '';

  raPath = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  clangdPath = "${pkgs.llvmPackages_latest.clang-unwrapped}/bin/clangd";
  cmakeLSPath = "${pkgs.cmake-language-server}/bin/cmake-language-server";
  goplsPath = "${pkgs.gopls}/bin/gopls";
  hlsWrapperPath = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
  pylsPath = "${pkgs.python38Packages.python-language-server}/bin/pyls";
  luaLSPath = "${pkdjz.luaLS.lua-lsp}/bin/lua-lsp";

  minKod = (readFile ./min.lua) + ''
    require'nvim-treesitter.configs'.setup {
      incremental_selection = {
        keymaps = {
  '' + (if iuzColemak then ''
    node_decremental = "<C-N>",
    node_incremental = "<C-E>",
  '' else ''
    node_decremental = "<C-J>",
    node_incremental = "<C-K>",
  '') + ''
        },
      },
    }
  '';

  medLangServers = {
    rust_analyzer = {
      cmd = [ raPath ];
      capabilities = { };
      settings.rust-analyzer = {
        procMacro.enable = true;
        cargo = { loadOutDirsFromCheck = true; };
        diagnostics.disabled = [ "unresolved-proc-macro" ];
      };
    };

    rnix = { cmd = [ "${pkgs.rnix-lsp}/bin/rnix-lsp" ]; };
    clangd = { cmd = [ clangdPath "--background-index" ]; };
    # cmake = { cmd = [ cmakeLSPath ]; }; # broken
  };

  maxLangServers = {
    pyls = { cmd = [ pylsPath ]; };
    gopls = { cmd = [ goplsPath ]; };
    hls = { cmd = [ hlsWrapperPath "--lsp" ]; };
  };

  langServers = optionalAttrs izUniksDev (
    (optionalAttrs saizAtList.med medLangServers) //
    (optionalAttrs saizAtList.max maxLangServers)
  );

  medKod = ''
    vim.g.UltiSnipsJumpBackwardTrigger = '<c-h>'
  '' + (if iuzColemak then ''
    vim.g.UltiSnipsJumpForwardTrigger = '<c-i>'
  '' else ''
    vim.g.UltiSnipsJumpForwardTrigger = '<c-l>'
  '');

  maxKod = ''
    vim.g.gitblame_enabled  = 0
    require('lspsaga').init_lsp_saga()
  '';

  medLuaKod = medKod
    + (readFile ./med.lua)
    + ctagsKod;

  maxLuaKod = maxKod;

  lsp_capabilities = {
    codeAction = {
      dynamicRegistration = false;
      codeActionLiteralSupport = {
        codeActionKind = {
          valueSet = [
            "quickfix"
            "refactor"
            "refactor.extract"
            "refactor.inline"
            "refactor.rewrite"
            "source"
            "source.organizeImports"
          ];
        };
      };
    };
    textDocument = {
      completion = { completionItem = { snippetSupport = true; }; };
    };
  };

  nioviNiks = {
    inherit lsp_capabilities langServers saizAtList;
  };

  nioviNiksFile = writeText "niovi-niks.json" (toJSON nioviNiks);
  niksPathLuaKod = ''
    local niks_path = '${nioviNiksFile}'
  '';

  luaModz = [ ];
  luaCModz = [ pkgs.luajit.pkgs.rapidjson ];

  mkLuaCPath = drv: "${drv}/lib/lua/${drv.lua.luaversion}/?.so";

  mkLuaPaths = drv: [
    "${drv}/share/lua/${drv.lua.luaversion}/?.lua"
    "${drv}/share/lua/${drv.lua.luaversion}/?/init.lua"
  ];

  luaModulesPaths = concatStringsSep ";"
    (optionals (luaModz != [ ]) (concatMap mkLuaPaths luaModz));

  luaCModulesPaths = concatStringsSep ";"
    (optionals (luaCModz != [ ]) (map mkLuaCPath luaCModz));

  loadLuaPathsKod = optionalString (luaModz != [ ]) ''
    package.path = package.path .. ";" .. [[${luaModulesPaths}]]
  '' + optionalString (luaCModz != [ ]) ''
    package.cpath = package.cpath .. ";" .. [[${luaCModulesPaths}]]
  '';

  initLuaKod = loadLuaPathsKod
    + niksPathLuaKod
    + (readFile ./vimLib.lua)
    + (readFile ./niovi.lua)
    + (optionalString iuzColemak readFile ./colemak.lua)
    + (readFile ./mappings.lua)
    + (optionalString (!iuzColemak) (readFile ./qwerty.lua))
    + (readFile ./dwm.lua)
    + treesitterParserz
    + (readFile ./treesitter.lua)
    + minKod
    + themeKod
    + (readFile ./expressline.lua)
    + (optionalString (izUniksDev && saizAtList.med)
    (medLuaKod + optionalString saizAtList.max maxLuaKod));

  luaVimrc = writeText "vimrc.lua" initLuaKod;

  minPackages = with pkgs; [ ];

  medPackages = with pkgs; [
    pkdjz.crate2nix
    llvmPackages_latest.clang
    universal-ctags
    go
    neovim-remote
    nixpkgs-fmt
    pkdjz.LuaFormatter
  ];

  maxPackages = with pkgs; [ ghc cabal-install stack ];

in
{
  home = {
    packages = minPackages
      ++ (optionals (izUniksDev && saizAtList.med)
      (medPackages ++ (optionals saizAtList.max maxPackages)));

    sessionVariables = {
      EDITOR =
        if saizAtList.med then
          "nvr -cc split --remote-wait +'set bufhidden=wipe'" else "nvim";
    };
  };

  programs = {
    neovim = {
      package = pkdjz.neovim;
      enable = true;
      withRuby = false;
      vimAlias = true;
      plugins = vimlPloginz ++ luaPloginz;

      extraConfig = readFile ./leftovers.vim
        + "luafile ${luaVimrc}";
    };

  };
}
