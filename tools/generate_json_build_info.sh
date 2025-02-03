#!/bin/bash
#
# Copyright (C) 2024 The Pixel Project
# Copyright (C) 2025 Project Zenith
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# $1=TARGET_DEVICE, $2=PRODUCT_OUT, $3=FILE_NAME
existingOTAjsonVanilla=./Devices/vanilla/$1.json
existingOTAjsonGapps=./Devices/gapps/$1.json
output=$2/$1.json

# Cleanup old file
if [ -f $output ]; then
    rm $output
fi

echo "Generating JSON file data for OTA support..."

# Determine build type based on file name
if [[ "$3" == *"GAPPS"* ]]; then
    buildtype="GAPPS"
elif [[ "$3" == *"VANILLA"* ]]; then
    buildtype="VANILLA"\else
    buildtype="UNKNOWN"
fi

# Choose the correct JSON file (prioritize GAPPS if both exist)
if [ -f $existingOTAjsonGapps ]; then
    existingOTAjson=$existingOTAjsonGapps
elif [ -f $existingOTAjsonVanilla ]; then
    existingOTAjson=$existingOTAjsonVanilla
else
    existingOTAjson=""
fi


if [ -n "$existingOTAjson" ]; then
    # Extract data from the existing device JSON
    maintainer=$(grep -m1 "\"maintainer\"" $existingOTAjson | cut -d ':' -f2- | tr -d '"', | xargs)
    oem=$(grep -m1 "\"oem\"" $existingOTAjson | cut -d ':' -f2- | tr -d '"', | xargs)
    device=$(grep -m1 "\"device\"" $existingOTAjson | cut -d ':' -f2- | tr -d '"', | xargs)
    filename=$3
    buildprop=$2/system/build.prop
    version=$(grep "ro.zenith.display.version" $2/system/build.prop | cut -d '=' -f2 | xargs)
    timestamp=$(grep "ro.system.build.date.utc" $buildprop | cut -d '=' -f2)
    md5=$(md5sum "$2/$3" | cut -d ' ' -f1)
    sha256=$(sha256sum "$2/$3" | cut -d ' ' -f1)
    size=$(stat -c "%s" "$2/$3")
    is_active=$(grep -m1 "\"is_active\"" $existingOTAjson | cut -d ':' -f2- | tr -d '"', | xargs)
    forum=$(grep -m1 "\"forum\"" $existingOTAjson | cut -d ':' -f2- | tr -d '"', | xargs)
    telegram=$(grep -m1 "\"telegram\"" $existingOTAjson | cut -d ':' -f2- | tr -d '"', | xargs)
    codename=$(grep "ro.zenith.device" $buildprop | cut -d '=' -f2 | xargs)

    echo '{
    "response": [
        {
            "maintainer": "'$maintainer'",
            "oem": "'$oem'",
            "device": "'$device'",
            "codename": "'$codename'",
            "version": "'$version'",
            "filename": "'$filename'",
            "download": "",
            "timestamp": '$timestamp',
            "md5": "'$md5'",
            "sha256": "'$sha256'",
            "size": '$size',
            "buildtype": "'$buildtype'",
            "is_active": "'$is_active'",
            "forum": "'$forum'",
            "telegram": "'$telegram'"
        }
    ]
}' >> $output
else
    # Handle unsupported devices
    filename=$3
    buildprop=$2/system/build.prop
    timestamp=$(grep "ro.system.build.date.utc" $buildprop | cut -d '=' -f2)
    version=$(grep "ro.zenith.display.version" $2/system/build.prop | cut -d '=' -f2 | xargs)
    md5=$(md5sum "$2/$3" | cut -d ' ' -f1)
    sha256=$(sha256sum "$2/$3" | cut -d ' ' -f1)
    size=$(stat -c "%s" "$2/$3")
    codename=$(grep "ro.zenith.device" $buildprop | cut -d '=' -f2 | xargs)

    echo '{
    "response": [
        {
            "maintainer": "",
            "oem": "",
            "device": "",
            "codename": "'$codename'",
            "version": "'$version'",
            "filename": "'$filename'",
            "download": "",
            "timestamp": '$timestamp',
            "md5": "'$md5'",
            "sha256": "'$sha256'",
            "size": '$size',
            "buildtype": "'$buildtype'",
            "is_active": "",
            "forum": "",
            "telegram": ""
        }
    ]
}' >> $output

    echo 'There is no official support for this device yet'
    echo 'Apply from https://github.com/ProjectZenithAOSP/Wiki/issues/new?template=device-maintainer-form.yml'
fi

echo ""

