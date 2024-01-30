# Code quality for Nuxt.js

<b>
Script to install dependencies and create init config file for code quality in Nuxt.js project:
Includes lint, prettier, husky, lint-staged, commit-lint, typescript support.
</b>

## Setting up

1. Run script to install dependencies and create init config file:

```bash
$ bash run.sh
```

2. Add lint run to your package.json:

```json
{
  "scripts": {
    //...
    "lint:js": "eslint --ext \".ts,.vue\" --ignore-path .gitignore .",
    "lint:prettier": "prettier --check .",
    "lint": "yarn lint:js && yarn lint:prettier",
    "lintfix": "prettier --write --list-different . && yarn lint:js --fix",
    "lint-staged": "lint-staged"
    //...
  }
}
```

3. (Optional) If you choose lint-staged + husky + commit-lint, add some code to your package.json:

```json
{
  //...
  "lint-staged": {
    "*.{js,ts,vue}": [
      "prettier --write",
      "eslint --fix",
      "git add"
    ]
  },
  "scripts": {
    //...
    "precommit": "husky"
    //...
  }
  //...
}
```

## DevDependencies & Docs

- [eslint](https://github.com/eslint/eslint),
  [prettier](https://github.com/prettier/prettier),
  [eslint-config-prettier](https://github.com/prettier/eslint-config-prettier),
  [eslint-plugin-prettier](https://github.com/prettier/eslint-plugin-prettier),
  [typescript-eslint](https://github.com/typescript-eslint/typescript-eslint),
  [nuxt-eslint-config](https://github.com/nuxt/eslint-config)
- [husky](https://github.com/typicode/husky),
  [lint-staged](https://github.com/lint-staged/lint-staged),
  [commit lint](https://github.com/conventional-changelog/commitlint),
  [commit lint config](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional)

