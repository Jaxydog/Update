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

section "apt" "sudo apt update" "sudo apt upgrade -qy" "sudo apt autoremove -qy"
section "rust" "rustup self update" "rustup upgrade"
section "snap" "sudo snap refresh"