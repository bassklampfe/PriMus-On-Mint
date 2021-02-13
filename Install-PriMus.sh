#!/bin/bash
set -e
bash 1.RequiredLinuxPackages.sh
bash 2.PrepareWinePrefix.sh
bash 3.DownloadFiles.sh
bash 4.ExtractPriMus.sh
bash 5.CreateMimeAndDesktopType.sh