#!/usr/bin/env bash

# shellcheck disable=SC2034
ANSI_GREEN="\033[32;1m"

set +e

echo -e "\\n${ANSI_GREEN}Checking out koreader for doc update."
git clone https://github.com/koreader/koreader.git ../koreader

# init base submodule
pushd ../koreader && {
    git submodule init base && git submodule update base
    git submodule init platform/android/luajit-launcher && git submodule update platform/android/luajit-launcher
} && popd || exit

pushd ../koreader/doc && {
    ldoc .
    ls -la
    if [ ! -d html ]; then
        echo "Failed to generate documents..."
        exit 1
    fi
} && popd || exit

cp -r ../koreader/doc/html/* .
{
    git diff
    git add -A
    echo -e "\\n${ANSI_GREEN}Pushing document update..."
    git -c user.name="KOReader build bot" -c user.email="non-reply@koreader.rocks" \
        commit -a --amend -m 'Automated documentation build from Github Actions.'
    #git push -f --quiet "https://${GITHUB_TOKEN}@github.com/koreader/doc.git" gh-pages >/dev/null
    echo -e "\\n${ANSI_GREEN}Documentation update pushed."
} || exit

