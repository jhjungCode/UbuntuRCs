"use strict";
exports.__esModule = true;
exports.activate = function (oni) {
    console.log("config activated");
    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", function () { return console.log("Control+Enter was pressed"); });
    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")
};
exports.deactivate = function (oni) {
    console.log("config deactivated");
};
exports.configuration = {
    //add custom config here, such as
    // "ui.colorscheme": "nord",
    "ui.colorscheme": "onedark",
    //"oni.useDefaultConfig": true,
    //"oni.bookmarks": ["~/Documents"],
    "oni.loadInitVim": "~/.config/oni/init.vim",
    "oni.exclude": [
        "node_modules",
        "dist",
        "tmp",
        "vendor",
        ".git",
        ".py[cd]"
    ],
    "editor.fontSize": "16px",
    "editor.fontFamily": "Ubuntu Mono",
    // UI customizations
    "ui.animations.enabled": true,
    "Ui.Fontsmoothing": "Auto"
};
