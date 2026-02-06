# List available commands
default:
    @just --list

# Update farzadmf-moves cask to a new version
# Usage: just update-moves [version]  (defaults to latest release)
update-moves version="":
    #!/usr/bin/env bash
    set -euo pipefail
    if [[ -z "{{version}}" ]]; then
        echo "Fetching latest version..."
        version=$(curl -s https://api.github.com/repos/farzadmf/Moves.app/releases/latest | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
    else
        version="{{version}}"
    fi
    echo "Updating to version ${version}"
    echo "Downloading and computing SHA256..."
    sha=$(curl -sL "https://github.com/farzadmf/Moves.app/releases/download/v${version}/Moves.zip" | shasum -a 256 | cut -d' ' -f1)
    echo "SHA256: ${sha}"
    if sed --version &>/dev/null; then
        sed -i "s/version \".*\"/version \"${version}\"/" Casks/farzadmf-moves.rb
        sed -i "s/sha256 \".*\"/sha256 \"$sha\"/" Casks/farzadmf-moves.rb
    else
        sed -i '' "s/version \".*\"/version \"${version}\"/" Casks/farzadmf-moves.rb
        sed -i '' "s/sha256 \".*\"/sha256 \"$sha\"/" Casks/farzadmf-moves.rb
    fi
    echo "Committing and pushing..."
    git add Casks/farzadmf-moves.rb
    git commit -q -m "Update farzadmf-moves to ${version}"
    git push -q
    echo "Done! Updated farzadmf-moves to ${version}"
