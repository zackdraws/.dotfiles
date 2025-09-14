# ✅ STEP 1: Open the UCRT64 shell
# Make sure you're in the UCRT64 environment:
echo $MSYSTEM
# Should output: UCRT64

# 📦 STEP 2: Install required packages
pacman -Syu --needed git go base-devel

# 📁 STEP 3: Clone the Syncthing repository
git clone https://github.com/syncthing/syncthing.git
cd syncthing

# 🧪 STEP 4: Confirm Go is set up
go version
# Example output: go version go1.21.5 windows/amd64

# Optional but safe:
export GOPATH=$HOME/go

# 🛠️ STEP 5: Build Syncthing
go run build.go

# ✅ STEP 6: Run Syncthing
./bin/syncthing

# 🌐 This will open the web UI at: http://localhost:8384

# (Optional) STEP 7: Install Syncthing globally
install -Dm755 bin/syncthing /usr/local/bin/syncthing

