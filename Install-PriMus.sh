#!/bin/bash
set -e
cd "$(dirname $(realpath "$0"))"
bash 1.RequiredLinuxPackages.sh
bash 2.PrepareWinePrefix.sh
bash 3.DownloadFiles.sh
bash 4.ExtractPriMus.sh
bash 5.CreateMimeAndDesktopType.sh
bash 6.InstallDesktopAddons.sh
