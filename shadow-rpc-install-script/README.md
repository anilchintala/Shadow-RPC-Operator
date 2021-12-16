# Notes on install script 

IMPORTANT: This script will only work on a Solana Server Program machine at an Equinix data center. For all other machiens, please see our 

Security updates, choose your password, set up user with sudo permissions:
```
sudo apt update -y;echo -ne '\n' | sudo apt upgrade -y;sudo apt-get dist-upgrade;echo -ne '\n' | adduser sol;echo "sol:[PASSWORD]" | chpasswd;usermod -aG sudo sol;su - sol
```

Download the script from SSC DAO Repo
```
sudo apt-get update

sudo apt-get install git

git clone https://github.com/Shadowy-Super-Coder-DAO/Shadow-RPC-Operator.git shadow-rpc-install-script

```
Execute script
```
cd ~/shadow-rpc-install-script
./rpc_install.sh
```
Partitioning
/dev/nvme0n1 is used only.

During making of swap file it can take up to 4 minutes, and the sleep is set for 5min. So please know that long pause is by design.

The result should be the machine start tailing the validator log. It can take up to 20 minutes to download a snapshot and begin catching up. The catchup can take up to 45 minutes as well.

This is a good time to test a reboot to make sure it can survive that without issues. Once done you can run some simply curls against the machine to check it.

Healthcheck
```
curl http://localhost:8899 -k -X POST -H "Content-Type: application/json" -d '
  {"jsonrpc":"2.0","id":1, "method":"getHealth"}
'
```

Tracking root slot
```
timeout 120 solana catchup --our-localhost=8899 --log --follow --commitment root
```

curl for getBlockProduction
```
curl http://localhost:8899 -k -X POST -H "Content-Type: application/json" -H "Referer: GGLabs" -d '{"jsonrpc":"2.0","id":1, "method":"getBlockProduction"}
'
```