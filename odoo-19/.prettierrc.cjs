// Prettier config — .cjs format, so @prettier/plugin-xml can be loaded even
// in an isolated pre-commit node environment. require.resolve() finds the plugin in the
// node_modules of the given hook, so no wrapper or --plugin is needed on the CLI.
// The same approach is used by OCA (oca-addons-repo-template).
const config = {
    plugins: [require.resolve("@prettier/plugin-xml")],
    tabWidth: 4,
    printWidth: 100,
    bracketSameLine: true,
    overrides: [
        {
            files: "*.xml",
            options: {
                xmlWhitespaceSensitivity: "preserve",
                xmlSelfClosingSpace: false,
                xmlSortAttributesByKey: false,
            },
        },
        {
            files: "*.md",
            options: {
                tabWidth: 2,
                proseWrap: "preserve",
            },
        },
    ],
};

module.exports = config;
