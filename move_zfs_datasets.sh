#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_zfs_pool> <target_zfs_pool>"
    exit 1
fi

# Get source and target ZFS pools from arguments
SOURCE_POOL="$1"
DEST_POOL="$2"

# Get a list of all datasets in the source pool
DATASETS=$(zfs list -H -o name -r $SOURCE_POOL | grep -v "@")

# Function to move a single dataset
move_dataset() {
    local dataset=$1

    # Get the base name of the dataset (without the pool name)
    local base_name=$(echo $dataset | sed "s|$SOURCE_POOL/||")

    # Take a snapshot of the dataset
    local snapshot_name="${dataset}@move"
    echo "Creating snapshot $snapshot_name"
    zfs snapshot $snapshot_name

    # Send the snapshot to the destination pool
    echo "Sending $snapshot_name to $DEST_POOL/$base_name"
    zfs send $snapshot_name | zfs receive $DEST_POOL/$base_name

    # Verify the transfer (optional step, can be more elaborate)
    if zfs list $DEST_POOL/$base_name >/dev/null 2>&1; then
        echo "Dataset $dataset successfully moved to $DEST_POOL/$base_name"
    else
        echo "Error: Failed to move $dataset to $DEST_POOL/$base_name"
        return 1
    fi

    # Optional: Remove the original dataset from the source pool
    # Uncomment the following line to enable deletion after successful move
    # zfs destroy $dataset
}

# Iterate over all datasets and move them
for dataset in $DATASETS; do
    move_dataset $dataset
done

echo "All datasets have been processed."
