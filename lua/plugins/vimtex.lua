return {
    "lervag/vimtex",
    lazy = false, -- vimtex は ftplugin で発火するので早めに読む
    init = function()
        -- Viewer: sioyek (SyncTeX 連携あり)
        vim.g.vimtex_view_method = "sioyek"

        -- Compiler: latexmk(~/.latexmkrc で lualatex + build/ を設定済み)
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_compiler_latexmk = {
            out_dir = "build",
            aux_dir = "build",
            options = {
                "-verbose",
                "-file-line-error",
                "-synctex=1",
                "-interaction=nonstopmode",
            },
        }

        -- QuickFix: 警告は表示しない(エラーのみ)
        vim.g.vimtex_quickfix_open_on_warning = 0

        -- Conceal は使わない(必要なら 2 に上げる)
        vim.g.vimtex_syntax_conceal_disable = 1

        -- メインファイル自動検出が外れた時の保険
        vim.g.tex_flavor = "latex"
    end,
}
