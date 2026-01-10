# List available commands
default:
    @just --list

# Update moves cask to a new version
# Usage: just update-moves 1.0.3
@update-moves version:
    #!/usr/bin/env bash
    set -euo pipefail
    sha=$(curl -sL "https://github.com/farzadmf/Moves/releases/download/v{{version}}/Moves.zip" | shasum -a 256 | cut -d' ' -f1)
    sed -i '' "s/version \".*\"/version \"{{version}}\"/" moves.rb
    sed -i '' "s/sha256 \".*\"/sha256 \"$sha\"/" moves.rb
    git add moves.rb
    git commit -m "Update moves to {{version}}"
    git push
