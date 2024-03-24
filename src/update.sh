#!/usr/bin/env bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright © 2024 Jaxydog
#
# This file is part of Update.
#
# Update is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# Update is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with Update. If not, see <https://www.gnu.org/licenses/>.

escape='\x1b['
reset="${escape}0m"
highlight_gray="${escape}0;100m"
highlight_green="${escape}0;42m"
highlight_red="${escape}0;41m"
italics="${escape}3m"
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
pin_file="$HOME/.update_pinned"
pinned=""

if [[ -f "$pin_file" ]]; then
    pinned=$(cat "$pin_file")
fi

function header() {
    echo -e "$highlight_gray $* $reset\n"
}
function success() {
    echo -e "$highlight_green $* $reset\n"
}
function failure() {
    echo -e "$highlight_red $* $reset\n"
}

function section() {
    header "Updating '$1'..."

    if [[ -n "$pinned" && "$pinned" == *"$1"* ]]; then
        success "Section '$1' is pinned."
        
        return 0
    fi

    for ((index = 2; index <= $#; index++)); do
        command="${!index}"

        echo -e "$italics> $command$reset\n"

        if ! $command; then
            failure "Failed to update '$1'!"

            return $?
        fi

        echo ""
    done

    success "Successfully updated '$1'."

    return 0
}

section 'apt' 'sudo apt update -q' 'sudo apt upgrade -qy' 'sudo apt autoremove -qy'
section 'rust' 'rustup self update' 'rustup upgrade'
section 'cargo' 'cargo install-update -ag'
section 'snap' 'sudo snap refresh'
section 'tldr' 'tldr --update'
section 'gradle' "$script_dir/update-gradle.sh"

