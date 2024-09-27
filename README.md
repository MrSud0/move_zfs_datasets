# ZFS Dataset Migration Script

## Overview

This script automates the process of moving all ZFS datasets from one ZFS pool to another. It takes snapshots of each dataset in the source pool, sends them to the target pool, and verifies the transfer. Optionally, the original datasets can be deleted from the source pool after a successful move.

## Requirements

- **Proxmox VE** or any Linux system with ZFS installed.
- The script assumes that ZFS is properly installed and configured on your system.

## Usage

### Step 1: Save the Script

Save the script as `move_zfs_datasets.sh` in your desired directory.

### Step 2: Make the Script Executable

Before running the script, make it executable by running the following command:

```bash
chmod +x move_zfs_datasets.sh
```

### Step 3: Run the Script

Run the script by providing the source and target ZFS pools as arguments. For example:

```bash
sudo ./move_zfs_datasets.sh <source_zfs_pool> <target_zfs_pool>
```

#### Example:

To move all datasets from a ZFS pool named `Images` to a ZFS pool named `vm-storage`:

```bash
sudo ./move_zfs_datasets.sh Images vm-storage
```

### Optional: Delete Source Datasets

The script includes an optional line that deletes the original datasets from the source pool after they have been successfully moved. This line is commented out by default. To enable this feature, uncomment the following line in the script:

```bash
# zfs destroy $dataset
```

## Script Details

- **Source Pool**: The ZFS pool from which datasets will be moved.
- **Target Pool**: The ZFS pool to which datasets will be moved.
- **Snapshot Creation**: The script creates a snapshot for each dataset in the source pool before sending it to the target pool.
- **Verification**: After each transfer, the script verifies that the dataset exists in the target pool.
- **Logging**: The script outputs the status of each operation to the terminal.

## Notes

- Ensure there is sufficient space in the target pool to accommodate the data being moved.
- Running this script may take time depending on the size of the datasets and the speed of your storage hardware.

## License

This script is provided as-is without any warranty. Use it at your own risk.

## Author
mrsudo



This `README.md` file provides a clear guide on how to use the script and includes necessary information for users to understand and safely run the script.
