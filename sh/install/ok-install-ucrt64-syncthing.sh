# Open the UCRT64 shell
# Make sure you're in the UCRT64 environment:
echo $MSYSTEM
# Install required packages
pacman -Syu --needed git go base-devel
# Clone the Syncthing repository
git clone https://github.com/syncthing/syncthing.git
cd syncthing
go version
export GOPATH=$HOME/go
go run build.go
./bin/syncthing
install -Dm755 bin/syncthing /usr/local/bin/syncthing

