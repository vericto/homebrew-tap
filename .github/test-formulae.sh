#!/usr/bin/env bash
# Style, audit, install and test every formula in this tap, as a user would
# get it: `brew install vericto/tap/<formula>` from the release archives.
#
# Run by .github/workflows/tests.yml, on macOS after Homebrew/actions/setup-homebrew
# has tapped the checkout, and on Linux inside the ghcr.io/homebrew/brew image
# with the checkout mounted at /tap. Locally: `brew tap vericto/tap <checkout>`,
# then `bash .github/test-formulae.sh` (it installs the formulae; uninstall
# them afterwards).
set -euxo pipefail

export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_ENV_HINTS=1

tap=vericto/tap
if [ -d /tap ] && ! brew tap | grep -qx "$tap"; then
  # A copy rather than `brew tap vericto/tap /tap`: the mount is read-only and
  # owned by another user, and a copy also works for a detached PR checkout.
  mkdir -p "$(brew --repository)/Library/Taps/vericto"
  cp -R /tap "$(brew --repository)/Library/Taps/vericto/homebrew-tap"
fi

# Homebrew loads formulae from third-party taps only once they are trusted
# (https://docs.brew.sh/Tap-Trust). A user's `brew install vericto/tap/vericto`
# trusts the formula it names; here, trust the tap under test.
brew trust --tap "$tap"

formulae=$(brew ruby -e "puts Tap.fetch('${tap}').formula_names")
[ -n "$formulae" ] || { echo "no formulae in ${tap}"; exit 1; }

# The formulae only: brew's actionlint configuration would reject this tap's
# own workflow variables (vars.CI_RUNS_ON).
brew style "$(brew --repository "$tap")/Formula"

for formula in $formulae; do
  # The release workflow of vericto/vericto-cli pushes the formula before it
  # announces the GitHub release, so the archives can be a few minutes away
  # from being downloadable: wait (up to 15 minutes) instead of failing on 404.
  url=$(brew ruby -e "puts Formula['${formula}'].stable.url")
  curl --fail --silent --show-error --location --head --output /dev/null \
    --retry 30 --retry-delay 30 --retry-all-errors "$url"

  brew audit --strict --online "$formula"
  brew install --formula "$formula"
  brew test "$formula"
  brew linkage --test "$formula"
done
