#! bin/bash

# this start by dealing with drive size larger than the default fdisk
# function likes to work with so we use gdisk for GPT partition and then
# remove it to use fdisk. the only dirty trick i know around this.

(
echo n # Add a new partition
echo 1 # Partition number
echo 2048 
echo 7501476494
echo 8300
echo p
echo w # Write changes
echo Y
) | sudo gdisk /dev/nvme0n1
echo

(
echo d # deleting gdisk partition and starting over with fdisk
echo n
echo p
echo 1
echo 2048 
echo +3000GB # about 7 days of ledger here
echo n
echo p
echo 2
echo 5859377152
echo +420GB # this will be made swap
echo w 
) | sudo fdisk /dev/nvme0n1
sudo -S mkfs -t ext4 /dev/nvme0n1p1 
OUTPUT="$(sudo blkid -s UUID -o value /dev/nvme0n1p1)"
echo "UUID="$OUTPUT"    /mt    ext4    auto nosuid,nodev,nofail 0 0" | sudo tee -a /etc/fstab
sudo mkfs -t ext4 /dev/nvme0n1p2
OUTPUT="$(sudo blkid -s UUID -o value /dev/nvme0n1p2)"
echo "UUID="$OUTPUT"   /mnt    ext4    auto nosuid,nodev,nofail 0 0" | sudo tee -a /etc/fstab
sudo snap install ufw
echo 'y' | sudo ufw enable
sudo ufw allow ssh
sudo ufw allow 53;sudo ufw allow 53/tcp;sudo ufw allow 53/udp;sudo ufw allow 8899;sudo ufw allow 8899/tcp;sudo ufw allow 8900/tcp;sudo ufw allow 8900/udp;sudo ufw allow 8901/tcp;sudo ufw allow 8901/udp;sudo ufw allow 9900/udp;sudo ufw allow 9900/tcp;sudo ufw allow 9900;sudo ufw allow 8899/udp;sudo ufw allow 8900;
sudo mkdir /mt;
sudo mkdir /mt/ledger;
sudo mkdir /mt/ledger/validator-ledger;
sudo mkdir ~/log;
sudo mkdir /mt/solana-accounts;
sudo chown sol:sol ~/log;
sudo chown sol:sol /mt/solana-accounts;
sudo chown sol:sol /mt/ledger/;
sudo chown sol:sol /mt/ledger/validator-ledger
sudo mount /dev/nvme0n1p2 /mnt;
sudo mount /dev/nvme0n1p1 /mt;
sudo swapoff /dev/sda2;
sudo swapoff /dev/sdb2;
sudo swapoff /dev/sdc2;
sudo sed --in-place '/swap.img/d' /etc/fstab;
sudo dd if=/dev/zero of=/mnt/swapfile bs=1M count=350k &
while ps -p $! > /dev/null; do sleep 300; done # this is a long sleep so be patient while swapile is made
sudo chmod 600 /mnt/swapfile;
sudo mkswap /mnt/swapfile;
echo "/mnt/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
sudo sysctl -p;
sudo swapon --all --verbose;
sudo -s cat << "EOF" > /home/sol/start-validator.sh
#!/bin/bash
# v0.5 Shadow Node ( updated 12/14/2021)
export SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=mainnet-beta,u=mainnet-beta_write,p=password
PATH=/home/sol/.local/share/solana/install/active_release/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
export RUST_BACKTRACE=1
export RUST_LOG=solana=info,solana_core::rpc=debug
export GOOGLE_APPLICATION_CREDENTIALS=/home/sol/solarchival-d87f0b4f3f3c.json
exec solana-validator \
    --identity ~/validator-keypair.json \
    --entrypoint entrypoint.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
    --entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
    --known-validator 7cVfgArCheMR6Cs4t6vz5rfnqd56vZq4ndaBrY5xkxXy \
    --known-validator DDnAqxJVFo2GVTujibHt5cjevHMSE9bo8HJaydHoshdp \
    --known-validator Ninja1spj6n9t5hVYgF3PdnYz2PLnkt7rvaw3firmjs \
    --known-validator wWf94sVnaXHzBYrePsRUyesq6ofndocfBH6EmzdgKMS \
    --known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
    --known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
    --known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
    --known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
    --rpc-port 8899 \
    --dynamic-port-range 8002-8020 \
    --no-port-check \
    --gossip-port 8001 \
    --no-untrusted-rpc \
    --no-voting \
    --private-rpc \
    --rpc-bind-address 0.0.0.0 \
    --rpc-send-retry-ms 10 \
    --enable-cpi-and-log-storage \
    --enable-rpc-transaction-history \
    --enable-rpc-bigtable-ledger-storage \
    --rpc-bigtable-timeout 600 \
    --account-index program-id \
    --account-index spl-token-owner \
    --account-index spl-token-mint \
    --rpc-pubsub-enable-vote-subscription \
    --no-duplicate-instance-check \
    --wal-recovery-mode skip_any_corrupted_record \
    --vote-account ~/vote-account-keypair.json \
    --log ~/log/solana-validator.log \
    --accounts /mt/solana-accounts \
    --ledger /mt/ledger/validator-ledger \
    --limit-ledger-size 700000000 \
    --rpc-pubsub-max-connections 1000 \
EOF

sudo chmod +x ~/start-validator.sh;
sudo chown sol:sol start-validator.sh;
sudo mkdir /mt;
sudo mkdir /mt/ledger;
sudo mkdir /mt/ledger/validator-ledger;
sudo mkdir ~/log;
sudo mkdir /mt/solana-accounts;
sudo chown sol:sol ~/log;
sudo chown sol:sol /mt/solana-accounts;
sudo chown sol:sol /mt/ledger/;
sudo chown sol:sol /mt/ledger/validator-ledger;
sudo cp /home/sol/rpc_script/sol.service /etc/systemd/system/sol.service;
sudo cp /home/sol/rpc_script/systuner.service /etc/systemd/system/systuner.service;
sudo cp /home/sol/rpc_script/log_rotate_solana /etc/logrotate.d/solana;

echo '
# sysctl_optimisations:
vm.max_map_count=1000000
kernel.nmi_watchdog=0
# Minimal preemption granularity for CPU-bound tasks:
# (default: 1 msec#  (1 + ilog(ncpus)), units: nanoseconds)
kernel.sched_min_granularity_ns=10000000
# SCHED_OTHER wake-up granularity.
# (default: 1 msec#  (1 + ilog(ncpus)), units: nanoseconds)
kernel.sched_wakeup_granularity_ns=15000000 
vm.swappiness=30
kernel.hung_task_timeout_secs=600
# this means that virtual memory statistics is gathered less often but is a reasonable trade off for lower latency
vm.stat_interval=10
vm.dirty_ratio=40
vm.dirty_background_ratio=10
vm.dirty_expire_centisecs=36000
vm.dirty_writeback_centisecs=3000
vm.dirtytime_expire_seconds=43200
kernel.timer_migration=0
# A suggested value for pid_max is 1024 * <# of cpu cores/threads in system>
kernel.pid_max=49152
net.ipv4.tcp_fastopen=3' | sudo tee -a /etc/sysctl.conf > /dev/null
sh -c "$(curl -sSfL https://release.solana.com/v1.8.5/install)" && export PATH="/home/sol/.local/share/solana/install/active_release/bin:$PATH"

echo | solana-keygen new -o ~/validator-keypair.json


echo | solana-keygen new -o ~/vote-account-keypair.json


solana config set --keypair ~/validator-keypair.json
echo
sudo systemctl daemon-reload;sudo systemctl restart logrotate
sudo systemctl enable --now systuner.service
sudo systemctl enable --now sol.service
sudo tail -f ~/log/solana-validator.log



#waiting
 #echo "Wait command" &
 #process_id=$!
 #wait $process_id
 #echo "Exited with status $?"

#sleeping 
 #echo “Wait for 5 seconds”
 #sleep 5
 #echo “Completed”