#!/bin/bash

## this script is used to install code quality tools for nuxt 3 project
## for newbie: you can run this script by using command: bash .script-code-quality-tools.sh . If using Windows, you can run it by using Git Bash
## release date: 2023-1-29
#
if command -v yarn &> /dev/null; then
    PACKAGE_MANAGER="yarn"
elif command -v npm &> /dev/null; then
    PACKAGE_MANAGER="npm"
else
    echo "Neither Yarn nor npm is installed. Please install one of them first."
    exit 1
fi

read -p "Enter your project path ( default: .): " PROJECT_PATH
cd "$PROJECT_PATH" || cd "."

read -p "Do you want setup husky, git-staged and commit-lint (y/n) ? " IS_SETUP_HUSKY
IS_SETUP_HUSKY=${IS_SETUP_HUSKY:-y}

echo "============================================================="
echo "---------------------- SCRIPT STARTED ----------------------"
echo "NOTE: you can configure quality tools with ide (vscode, phpstorm, webstorm, ...)"
echo "============================================================="

# lint + prettier + typescript support

if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    yarn add -D eslint;
    yarn add -D prettier eslint-config-prettier eslint-plugin-prettier;
    yarn add -D typescript @typescript-eslint/parser @nuxtjs/eslint-config-typescript;
else
    npm i -D eslint;
    npm i -D prettier eslint-config-prettier eslint-plugin-prettier;
    npm i -D typescript @typescript-eslint/parser @nuxtjs/eslint-config-typescript
fi

echo "module.exports = {
          root: true,
          env: {
              browser: true,
              node: true,
          },
          parser: 'vue-eslint-parser',
          parserOptions: {
              parser: '@typescript-eslint/parser',
          },
          extends: ['@nuxtjs/eslint-config-typescript', 'plugin:prettier/recommended'],
          plugins: [],
          rules: {
              'vue/no-multiple-template-root': 'off',
              '@typescript-eslint/no-unused-vars': 'warn',
              'require-await': 'warn',
              'vue/multi-word-component-names': 'off',
              'vue/no-dupe-keys': 'off',
              'no-use-before-define': 'warn',
          },
          ignorePatterns: ['node_modules', '.nuxt', 'dist'],
      };" >| .eslintrc.cjs


# add script to package.json
#echo ">>>>> create lint script file"
#
#if [ ! -f "package.json" ]; then
#    $PACKAGE_MANAGER init -y
#fi
#
#echo '{
#    "lint:js": "eslint --ext \".ts,.vue\" --ignore-path .gitignore .",
#    "lint:prettier": "prettier --check .",
#    "lint": "yarn lint:js && yarn lint:prettier",
#    "lintfix": "prettier --write --list-different . && yarn lint:js --fix"
#}' > lint_run_script.json

#echo "NOTE: You should copy content of lint_run_script.json and paste it to your 'script' key of package.json file"

echo "
node_modules
*.log*
.nuxt
.nitro
.cache
.output
.env
dist
.idea" >| .prettierignore

# add husky, git-staged and commit-lint
if [ "$IS_SETUP_HUSKY" = "y" ]; then
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
        yarn add -D husky @commitlint/cli @commitlint/config-conventional;
        yarn add -D lint-staged;
    else
        npm i -D husky @commitlint/cli @commitlint/config-conventional;
        npm i -D lint-staged;
    fi

    npx husky init

    echo "module.exports = {
      extends: ['@commitlint/config-conventional'],
    };" >| .commitlintrc.js

    echo '#!/usr/bin/env sh
    . "$(dirname -- "$0")/_/husky.sh"

    npx lint-staged' >| .husky/pre-commit

    echo '#!/bin/sh
          . "$(dirname "$0")/_/husky.sh"

          npx --no-install commitlint --edit "$1"' >| .husky/commit-msg
fi


echo "============================================================="
echo "---------------------- SCRIPT FINISHED ----------------------"
echo "============================================================="

exit 0
