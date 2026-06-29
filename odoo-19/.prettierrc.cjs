// Prettier konfig — .cjs formát, aby sa @prettier/plugin-xml dal načítať aj
// v izolovanom pre-commit node prostredí. require.resolve() nájde plugin v
// node_modules daného hooku, takže netreba wrapper ani --plugin na CLI.
// Rovnaký prístup používa OCA (oca-addons-repo-template).
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
