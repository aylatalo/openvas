#!/bin/bash
#
# greenbone-feed-sync-local.sh
#
# This script updates local OpenVAS mirrors from Greenbone Community Feeds
# 
# Lukas Grunwald <lukas.grunwald@greenbone.net>
# Jan-Oliver Wagner <jan-oliver.wagner@greenbone.net>
# Michael Wiegand <michael.wiegand@greenbone.net>
# Anssi Ylätalo <anssi.ylatalo@kymp.net>
#
# Copyright (C) 2009-2016 Greenbone Networks GmbH
# Copyright (C) 2018 Anssi Ylätalo
#               
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

## Feed mirror directories
## Setup according your needs
NVT_DIR=/var/lib/openvas/feed-mirror/nvt-feed
SCAP_DIR=/var/lib/openvas/feed-mirror/scap-data
CERT_DIR=/var/lib/openvas/feed-mirror/cert-data

## No need to edit below this line
PRIVATE_SUBDIR="private"
RSYNC_DELETE_NVT="--delete --exclude $PRIVATE_SUBDIR/"
RSYNC_DELETE_SCAP="--delete --exclude scap.db --exclude \"$PRIVATE_SUBDIR/\""
RSYNC_DELETE_CERT="--delete --exclude cert.db --exclude \"$PRIVATE_SUBDIR/\""
 
COMMUNITY_NVT_RSYNC_FEED="rsync://feed.openvas.org:/nvt-feed"
COMMUNITY_SCAP_RSYNC_FEED="rsync://feed.openvas.org:/scap-data"
COMMUNITY_CERT_RSYNC_FEED="rsync://feed.openvas.org:/cert-data"

ERROR=0
 
echo "INFO: Greenbone Community Feed sync to local repository"
date
echo "INFO: Syncing NVT feed"
if rsync -ltvrP $RSYNC_DELETE_NVT "$COMMUNITY_NVT_RSYNC_FEED" "$NVT_DIR" ;then
        echo "INFO: NVT feed synced successfully"
else
        echo "ERROR: Cannot sync NVT feed"
        ERROR=1
fi
 
echo "INFO: Syncing SCAP feed"
date
if rsync -ltvrP $RSYNC_DELETE_SCAP "$COMMUNITY_SCAP_RSYNC_FEED" "$SCAP_DIR" ;then
        echo "INFO: SCAP feed synced successfully"
else
        echo "ERROR: Cannot sync SCAP feed"
        ERROR=1
fi
 
echo "INFO: Syncing CERT feed"
date
if rsync -ltvrP $RSYNC_DELETE_CERT "$COMMUNITY_CERT_RSYNC_FEED" "$CERT_DIR" ;then
        echo "INFO: CERT feed synced successfully"
else
        echo "ERROR: Cannot sync CERT feed"
        ERROR=1
fi

date 
if [[ $ERROR -lt 1 ]]; then
        echo "INFO: All feeds synced succesfully"
        exit 0
else
        echo "WARNING: Some feeds not synced succesfully"
        exit 1
fi
