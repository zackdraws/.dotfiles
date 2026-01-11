#!/bin/bash
GO_VERSION="1.21.1"
GO_ZIP="go${GO_VERSION}.windows-amd64.zip"
GO_URL="https://go.dev/dl/${GO_ZIP}"
INSTALL_DIR="/c/Go"
echo "Downloading Go $GO_VERSION..."
curl -LO "$GO_URL" || { echo "Download failed"; exit 1; }
echo "Extracting Go archive..."
unzip -o "$GO_ZIP" || { echo "Failed to unzip"; exit 1; }
echo "Moving Go folder to $INSTALL_DIR..."
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing $INSTALL_DIR"
    rm -rf "$INSTALL_DIR"
fi
mv go "$INSTALL_DIR" || { echo "Failed to move Go directory"; exit 1; }
echo "Cleaning up ZIP file..."
rm "$GO_ZIP"
echo "Adding Go to PATH for this session..."
export PATH=$PATH:"$INSTALL_DIR/bin"
echo "Adding Go to PATH permanently in ~/.bashrc..."
grep -qxF "export PATH=\$PATH:$INSTALL_DIR/bin" ~/.bashrc || echo "export PATH=\$PATH:$INSTALL_DIR/bin" >> ~/.bashrc
echo "Reloading ~/.bashrc..."
source ~/.bashrc
echo "Verifying Go installation..."
go version || { echo "Go installation failed"; exit 1; }
echo "Go $GO_VERSION installed successfully!"
