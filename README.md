# Setting Up a Signer Node

Although setting up a signer node may seem technically challenging, we've simplified the process as much as possible. If you need further clarification or encounter any issues, don't hesitate to contact me at [silas.stulz@bcts.ch](mailto:silas.stulz@bcts.ch?subject=SwissDLT%20Setup%20Support).

You can run a SwissDLT node in one of two ways: in a container or via source installation. Both methods require setting up a Virtual Machine (VM).

## 1. Virtual Machine Setup

### 1.1 Azure

#### 1.1.1 Creating a VM

**BASICS**

Create a new VM in Azure with the following properties:

- **Resource group** Create a new one.
- **Region**: (Europe) Switzerland North
- **Image**: Ubuntu Server 22.04 LTS
- **VM Architecture**: x64
- **Size**: Minimum "B1ms", but "B2s" or similar is recommended.
- **Authentication type**: If you're familiar with SSH certificates, please create one and use it. However, password-based access is also acceptable.

Keep the default settings for the other fields. Proceed to the "Disks" section.

**DISKS**

- **OS disk size**: 128 GiB. This should provide ample space for the growing blockchain.

Keep the default settings for the other fields. Proceed to "Networking".

**NETWORKING**

A virtual network, a subnet, and a public IP should be assigned by default. If there's no virtual network assigned, create a new one. Click "Create new", enter a name, and leave the rest as is. This action should automatically set a subnet and a public IP.

Keep the default settings for the other fields and proceed to "Review + create". If there are no errors, create the VM.

#### 1.1.2 Opening Required Ports

- Navigate to your newly created VM.
- Click the "Networking" tab.
- Select "Add inbound port rule".
- In "Destination port ranges", enter **30300-30310**.
- Click "Add".

Your VM can now connect to other nodes. Let's continue with the final setup. Proceed to Chapter 2.

### 1.2 AWS

## 2. Virtual Machine Installation

- Connect to your virtual machine (the one you just set up) via SSH. You can find that information under the "Connect" tab on Azure

  ```ssh username@ip``` 


- Clone the git repository:

  ```git clone https://github.com/BlockchainTrustSolutions/SwissDLT-Node-Setup```


- Navigate to the cloned repository:

  ```cd SwissDLT-Node-Setup/```


- Make the script executable:

  ```chmod +x signer_setup.sh```


- Run the script, replacing "YOUR_PASSWORD" with your chosen password:

  ```sudo ./signer_setup.sh YOUR_PASSWORD``` e.g. ```sudo ./signer_setup.sh 123```


- During the script execution, confirm any operations by responding with "yes" or "y".


- If successful, your public key should be displayed. For instance: 0x453BF47b6c8E9b466f463D1b1D487C9aC35A952B


- If you don't see this output, check the account.txt file:

  ```cat account.txt```


- Please share the public key with Toni or Silas, so we can add you as a signer.


- To verify everything is running correctly, enter:

  ```systemctl status geth```


- Under the section "Active" it should be written a green "active (running)".


- You can also check the logs by entering:

  ```journalctl -u geth -n 20```


- If you see messages like "Imported new chain segment" and "Looking for peers", everything seems to be in order.

Congratulations! You're now running a node in the SwissDLT network!

## 3. Docker Setup

Coming Soon!