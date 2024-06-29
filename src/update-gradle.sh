#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright © 2024 Jaxydog
# Copyright © 2024 RemasteredArch
#
# This file is part of Update.
#
# Update is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# Update is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with Update. If not, see <https://www.gnu.org/licenses/>.

function fail() {
    echo "Unable to update Gradle."

    # shellcheck disable=SC2086
    exit $1
}

function install() {
    echo -e "Installing Gradle '$1'...\n"

    local output='/opt/gradle'

    echo "Be sure to add the following environment variables:"
    echo "- GRADLE_HOME=\"$output\""
    echo -e "- PATH=\"$output/bin:\$PATH\"\n"

    # Ensure the directory exists and is empty.
    if [[ ! -d "$output" ]]; then
        sudo mkdir "$output"
    elif [[ -n "$(ls -A $output)" ]]; then
        sudo rm -r "$output/*"
    fi

    echo 'Downloading latest zip...'

    local download_url=$(echo "$2" | jq --raw-output .downloadUrl)
    local gradle="gradle-$1"

    wget -q "$download_url" || fail $?

    echo 'Unzipping...'

    unzip -q "./$gradle-bin.zip" || fail $?

    echo "Installing..."

    sudo cp -a "./$gradle/." "$output" || fail $?

    echo "Cleaning up..."

    rm -r "./$gradle"
    rm "./$gradle-bin.zip"

    echo "Installation completed."
    exit 0
}


echo -e 'Checking for latest version...\n'

response=$(curl --silent 'https://services.gradle.org/versions/current')
latest_version=$(echo "$response" | jq --raw-output .version)

echo "Latest version: '$latest_version'"

installed=$(command -v gradle 2> /dev/null)

if [[ $installed ]]; then
    installed_version=$(gradle --version | grep 'Gradle' | grep --only-matching '[0-9]\.[0-9]' 2> /dev/null)

    echo -e "Installed version: '$installed_version'\n"

    if [[ $installed_version == "$latest_version" ]]; then
        echo "Gradle is up to date ('$installed_version' == '$latest_version')!"
        exit 0
    else
        echo "Gradle is out of date ('$installed_version' < '$latest_version')!"
        echo -n 'Would you like to update Gradle? (y/n) '

        # Ignore casing
        read -n 1 should_install
        should_install=${should_install,,}

        echo

        if [[ "$should_install" == 'y' ]]; then
            echo ''
            install "$latest_version" "$response"
        fi
    fi
else
    echo -e 'Installed version: Not installed.\n'
    echo -n 'Would you like to install Gradle? (y/n) '

    # Ignore casing
    read -n 1 should_install
    should_install=${should_install,,}

    echo

    [[ "$should_install" == 'y' ]] && {
        echo
        install "$latest_version" "$response"
    }
fi
