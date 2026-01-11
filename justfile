# List available commands
default:
    @just --list

# Update moves cask to a new version
# Usage: just update-moves 1.0.3
update-moves version:
    #!/usr/bin/env bash
    set -euo pipefail
    sha=$(curl -sL "https://github.com/farzadmf/Moves/releases/download/v{{version}}/Moves.zip" | shasum -a 256 | cut -d' ' -f1)
    if sed --version &>/dev/null; then
        sed -i "s/version \".*\"/version \"{{version}}\"/" Casks/moves.rb
        sed -i "s/sha256 \".*\"/sha256 \"$sha\"/" Casks/moves.rb
    else
        sed -i '' "s/version \".*\"/version \"{{version}}\"/" Casks/moves.rb
        sed -i '' "s/sha256 \".*\"/sha256 \"$sha\"/" Casks/moves.rb
    fi
    git add Casks/moves.rb
    git commit -q -m "Update moves to {{version}}"
    git push
