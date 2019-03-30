# Auto Pi

Quick and dirty script to get a headless Raspberry Pi ready to use.

- Latest Raspbian Lite
- Auto-join Wifi
- Switch SSH to key-only mode
- Preload a ssh key for `pi`
- Enable SSH

## /boot/boot.rc

The current Raspbian makes enabling Wifi and SSH easy via creating files in /boot.
However this just reverts SSH back to the insecure known password mode they removed.
Instead this script re-enables the old `/boot/boot.rc` file, and uses it to securely configure SSH.
