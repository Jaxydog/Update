#!/usr/bin/env bash

# SPDX-License-Identifier: AGPL-3.0-or-later
#
# Copyright © 2024 Jaxydog
#
# This file is part of Update.
#
# Update is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
# Update is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License along with Update. If not, see <https://www.gnu.org/licenses/>.

function header() {
    echo -e "\033[0;100m$1\033[0m\n"
}
function success() {
    echo -e "\033[0;42m$1\033[0m\n"
}
function failure() {
    echo -e "\033[0;41m$1\033[0m\n"
}

function section() {
    header "Updating '$1'"

    for ((index = 2; index <= $#; index++)); do
        command="${!index}"

        if ! $command; then
            failure "Failed to update '$1'"

            return $?
        fi

        echo ""
    done

    success "Successfully updated '$1'"

    return 0
}

section "apt" "sudo apt update -q" "sudo apt upgrade -qy" "sudo apt autoremove -qy"
section "rust" "rustup self update" "rustup upgrade"
section "snap" "sudo snap refresh"
section "tldr" "tldr --update"