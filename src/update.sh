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

function set_color() {
    color_name="$1"
    ansi_control_code="$2"

    colors[$color_name]="\e[${ansi_control_code}m"

    unset color_name ansi_control_code
}

declare -A colors

set_color reset 0
set_color bold 1
set_color italics 3
set_color black 30
set_color white 97
set_color highlight_gray 100
set_color highlight_green 42
set_color highlight_red 41
set_color highlight_blue 46

unset set_color

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
pin_file="${XDG_CONFIG_HOME:-"$HOME/.config"}/update/pinned"
pinned=""

[ -f "$pin_file" ] && pinned=$(cat "$pin_file")

function message() {
    local highlight_color="$1"
    local text_color="$2"
    shift 2

    echo -e "\n${colors[$highlight_color]}${colors[$text_color]} $* ${colors[reset]}\n"
}

function header() {
    message 'highlight_gray' 'white' "$*"
}
function success() {
    message 'highlight_green' 'black' "$*"
}
function failure() {
    message 'highlight_red' 'black' "$*"
}
function pinned() {
    message 'highlight_blue' 'black' "$*"
}

function section() {
    local name="$1"
    shift

    header "Updating '$name'..."

    [ -n "$pinned" ] && [[ "$pinned" == *"$name"* ]] && {
        echo -e "To edit pinned sections, edit '$pin_file'."

        pinned "Section '$name' is pinned."
        
        return 0
    }

    for command in "$@"; do
        echo -e "> ${colors[italics]}$command${colors[reset]}\n"

        $command || {
            local exit_code=$?
            failure "Failed to update '$name'!"

            return $exit_code
        }
    done

    success "Successfully updated '$name'."

    return 0
}

section 'apt' 'sudo apt update -q' 'sudo apt upgrade -qy' 'sudo apt autoremove -qy'
section 'rust' 'rustup self update' 'rustup upgrade'
section 'cargo' 'cargo install-update -ag'
section 'snap' 'sudo snap refresh'
section 'tldr' 'tldr --update'
section 'gradle' "$script_dir/update-gradle.sh"
