# Shadow-RPC-Operator
Shadow Operator resources for running a high performance &amp; high stability Shadow Node to earn rewards
# Overview

This resource has a step by step guide of
1) Configuring a Shadow Node
2) Connecting the Shadow Node to the SSC-DAO Shadow Network
3) Maintaining your Shadow Node for maximum rewards payouts

If you are just getting started, walking through the 1-Configuring a Shadow Node will be immensely helpful in learning the design of the machines and basic linux commands.

For users that feel confident in their knowledge of linux systems, we also provide a bash install script. This script attempts to install the entire configuration if the following criteria has been met:
1) You have a server through the Solana Server Program of the CPU type 75xx or 7402 with 3.8TB nvme drives. Anything different will fail.
2) You have accessed your machine and created a user "sol" with sudo privileges 
3) Downloaded the entire file: "shadow-rpc-install-script" to your /home/sol location.

We encourage all Shadow Operators to at the very least read through the step 1-3 guide to become familiar with what the script installer will do. Otherwise if your machines breaks you may not be able to fix it before the penalties and reward slashing kick in.

# Other Resources & Learning
Official Solana RPC resources to reference are located in the Solans Documentation here: https://docs.solana.com/running-validator

For developers interested in a more automated control we are releasing a advanced Shadow Node operator manual in due time.

For more advanced developers and those interested in deploying their node and scaling their Shadow Node(s) with the ansible automation engine please see this resource by Triton: https://github.com/rpcpool


# Credits
Thanks to the great group at rpcpool / Triton for their support in the Solana RPC Discord channel and for providing the broader community their resources. 

We also learned very early from agjell (andrebo in Discord) who more focuses on validators but offered a great guide that helped many of the validators you see running today get online. If you are also interested in getting your very own validator up and running check his repo out: https://github.com/agjell/sol-tutorials

Finally, thanks to everyone that actively offers help and advice in the Solana Discord and the SSC DAO discord. 

Don't be afraid to ask questions!