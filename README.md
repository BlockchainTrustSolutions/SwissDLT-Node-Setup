# Setup a Signer Node

As setting up a signer node might be a technical task, I tried to simplify it as much as possible. Still, if something is unclear or you need support, contact me anytime at [silas.stulz@bcts.ch](mailto:silas.stulz@bcts.ch?subject=SwissDLT Setup Support)

There are currently two possible ways to run a SwissDLT node, in a container or a source installation. For either of them you need to setup a VM.

## 1. Virtual Machine Setup

### 1.1 Azure

**BASICS**

Create a new VM in Azure with the following properties:

Region: (Europe) Switzerland North
Image: Ubuntu Server 22.04 LTS
VM Architecture: x64
Size: At least something like "B1ms" better "B2s" or similar.

Authentication: If you are familiar on how to use an SSH certificate please create one and use it. Otherwise it is fine to use a password based access.

Otherwise keep the default settings.

**DISKS**
OS disk size: 128 GiB. This will give you enough space in case the blockchain gets bigger in size.


### 1.2 AWS

## 2. Virtual Machine installation

- Connect to your virtual machine you setup via SSH.


- Pull the git repository:

  ```git clone https://github.com/BlockchainTrustSolutions/SwissDLT-Node-Setup```


- Move into the folder

  ```cd SwissDLT-Node-Setup/```


- Make the script executable

  ```chmod +x signer_setup.sh```


- Execute the script with your password

  ```./signer_setup.sh REPLACE_WITH_YOUR_PASSWORD``` e.g ```./signer_setup.sh 123```


You will have to allow a few operations as the script is running. When requested please enter with yes or y.

When the script ran successfully you will see your public key as output. E.g 0x453BF47b6c8E9b466f463D1b1D487C9aC35A952B

If you do not see that output, check the account.txt file:

```cat account.txt```

Please share the public key with Toni or Silas, so we can add you as a signer.

- Let's check if everything is running as it should.

  ```systemctl --user --type=service --state=active```

- You should see something like this: 
  ``` 
  UNIT         LOAD   ACTIVE SUB     DESCRIPTION
  geth.service loaded active running SignerNode```

- You can also check the logs:

  ```journalctl --user-unit=geth.service```

  If you see outputs like "Imported new chain segment" and "Looking for peers" everything seems fine.

Congrats! You are now running a node in the SwissDLT network!

## 3. Docker Setup

Coming Soon!