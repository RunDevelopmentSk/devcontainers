// ESLint flat config (eslint 9) for Odoo OWL frontend code in extra-addons.
//
// The rule set is taken from Odoo 19 CE core — addons/test_lint/tests/eslintrc,
// which core runs against its own JS (see addons/test_lint/tests/test_eslint.py).
// Only correctness rules are enabled: formatting is prettier's job, so nothing
// here overlaps with it (no indent/quotes/semi rules).
//
// .cjs, not .js — the repo has no package.json, so node treats bare .js as CommonJS
// anyway, but the explicit extension keeps it unambiguous for the pre-commit node env.

const odooRules = {
    // --- Rules mirrored from Odoo core eslintrc ---
    "no-undef": "error",
    "no-const-assign": "error",
    "no-debugger": "error",
    "no-dupe-class-members": "error",
    "no-dupe-keys": "error",
    "no-dupe-args": "error",
    "no-dupe-else-if": "error",
    "no-unsafe-negation": "error",
    "no-duplicate-imports": "error",
    "valid-typeof": "error",
    // args: "none" — OWL/Odoo callbacks often must keep a fixed signature.
    // caughtErrors: "all" — use `catch {}` when the error is unused (core does this
    // in 249 places).
    "no-unused-vars": [
        "error",
        { vars: "all", args: "none", ignoreRestSiblings: false, caughtErrors: "all" },
    ],
};

const browserGlobals = {
    window: "readonly",
    document: "readonly",
    console: "readonly",
    navigator: "readonly",
    location: "readonly",
    history: "readonly",
    fetch: "readonly",
    setTimeout: "readonly",
    clearTimeout: "readonly",
    setInterval: "readonly",
    clearInterval: "readonly",
    requestAnimationFrame: "readonly",
    localStorage: "readonly",
    sessionStorage: "readonly",
    confirm: "readonly",
    alert: "readonly",
    prompt: "readonly",
    URL: "readonly",
    Blob: "readonly",
    FormData: "readonly",
    FileReader: "readonly",
    Image: "readonly",
    MediaRecorder: "readonly",
    AbortController: "readonly",
    CustomEvent: "readonly",
    Event: "readonly",
    globalThis: "readonly",
};

// Globals Odoo injects into the frontend runtime (subset of core's eslintrc that we
// actually use; add more here if a module starts relying on them).
const odooGlobals = {
    odoo: "readonly",
    $: "readonly",
    jQuery: "readonly",
    luxon: "readonly",
};

module.exports = [
    {
        files: ["extra-addons/**/static/src/**/*.js"],
        languageOptions: {
            ecmaVersion: 2022,
            sourceType: "module",
            globals: { ...browserGlobals, ...odooGlobals },
        },
        rules: odooRules,
    },
    {
        // Service workers run in ServiceWorkerGlobalScope — `self`, `caches` and
        // `clients` are legitimate there, unlike in regular frontend code.
        files: ["extra-addons/**/static/src/pwa/sw.js"],
        languageOptions: {
            globals: {
                self: "readonly",
                caches: "readonly",
                clients: "readonly",
                skipWaiting: "readonly",
            },
        },
    },
];
