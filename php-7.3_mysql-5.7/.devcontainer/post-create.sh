#!/bin/bash
# this script is used as "postCreateCommand" in devcontainer.json

# install python requirements
echo "" && echo "Installing python packages..."
# NOTE: Run it using `sudo` as `--break-system-packages` is not availble for pip in this image
sudo pip install -r ./.devcontainer/requirements.txt

# install CLI tools using pipx
echo "" && echo "Installing runtools..."
pipx install "runtools @ git+https://git@github.com/RunDevelopmentSk/runtools.git@main"

# git: add safe.directory exception for workspace folder (* = for any folder in fact)
# because the project folder is bind-mounted from the host where it may be owned by
# a different UID than the container user. This is mostly case on Windows.
# Use append (>>) to avoid EBUSY caused by atomic rename on bind-mounted file.
if ! grep -qE '^[[:space:]]*directory[[:space:]]*=[[:space:]]*\*[[:space:]]*$' "$HOME/.gitconfig" 2>/dev/null; then
    printf '\n[safe]\n\tdirectory = *\n' >> "$HOME/.gitconfig"
fi

# git: install pre-commit hooks
echo "" && echo "Installing precommit..."
pre-commit install
