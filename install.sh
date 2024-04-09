#!/usr/bin/env bash

# Define colors
bold="\e[1m"
blue="\e[38;5;105m"  # Light blue
green="\e[38;5;76m"   # Green
red="\e[38;5;203m"    # Red
yellow="\e[38;5;226m" # Yellow
end="\e[0m"

show_banner() {
    clear
    echo ""
    echo ""
    echo ""
    echo -e "${bold}${green}  ██████  █    ██  ▄▄▄▄        ██████  ▄████▄   ▒█████   ██▓███  ▓█████     ${end}"
    echo -e "${bold}${green} ▒██    ▒  ██  ▓██▒▓█████▄    ▒██    ▒ ▒██▀ ▀█  ▒██▒  ██▒▓██░  ██▒▓█   ▀    ${end}"
    echo -e "${bold}${green} ░ ▓██▄   ▓██  ▒██░▒██▒ ▄██   ░ ▓██▄   ▒▓█    ▄ ▒██░  ██▒▓██░ ██▓▒▒███      ${end}"
    echo -e "${bold}${green}   ▒   ██▒▓▓█  ░██░▒██░█▀       ▒   ██▒▒▓▓▄ ▄██▒▒██   ██░▒██▄█▓▒ ▒▒▓█  ▄    ${end}"
    echo -e "${bold}${green} ▒██████▒▒▒▒█████▓ ░▓█  ▀█▓   ▒██████▒▒▒ ▓███▀ ░░ ████▓▒░▒██▒ ░  ░░▒████▒   ${end}"
    echo -e "${bold}${green} ▒ ▒▓▒ ▒ ░░▒▓▒ ▒ ▒ ░▒▓███▀▒   ▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░░ ▒░▒░▒░ ▒▓▒░ ░  ░░░ ▒░ ░   ${end}"
    echo -e "${bold}${green} ░ ░▒  ░ ░░░▒░ ░ ░ ▒░▒   ░    ░ ░▒  ░ ░  ░  ▒     ░ ▒ ▒░ ░▒ ░      ░ ░  ░   ${end}"
    echo -e "${bold}${green} ░  ░  ░   ░░░ ░ ░ ░    ░    ░  ░  ░  ░        ░ ░ ░ ▒  ░░          ░       ${end}"
    echo -e "${bold}${green}       ░     ░      ░               ░  ░ ░          ░ ░              ░  ░    ${end}"
    echo -e "${bold}${red}                      DEvELoPeD By Sdx - SaGaR DhEkLe                          ${end}"
    echo
    sleep 3
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install required tools
install_tools() {
    local tools=("curl" "awk" "sort" "tr" "grep" "sed" "findomain" "subfinder" "amass" "assetfinder")
    local success=true

    echo -e "${bold}${blue}Checking and installing required tools:${end}"
    for tool in "${tools[@]}"; do
        printf "Checking for $tool..."
        if ! command_exists "$tool"; then
            echo -e "\r${red}Installing $tool...${end}"
            sudo apt-get install -y $tool >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo -e "\r${green}$tool installed successfully.${end}"
            else
                echo -e "\r${red}Failed to install $tool.${end}"
                success=false
            fi
        else
            echo -e "\r${green}$tool is already installed.${end}"
        fi
    done

    if $success; then
        echo -e "${bold}${blue}All required tools are installed.${end}"
    else
        echo -e "${bold}${red}Some tools failed to install.${end}"
    fi
}

# Function to copy the script to /usr/local/bin and set permissions
copy_script() {
    echo ""
    echo -e "${bold}${blue}Copying SubScope script to /usr/local/bin...${end}"
    sudo cp subscope.sh /usr/local/bin/subscope >/dev/null 2>&1
    sudo chmod +x /usr/local/bin/subscope >/dev/null 2>&1
    echo -e "${bold}${blue}SubScope script copied.${end}"
}

# Function to display completion message
completion_message() {
    echo ""
    echo -e "${bold}${green}Installation complete!${end}"
    echo "You can now use the 'subscope' command to run the SubScope subdomain enumeration tool."
    echo ""
}

# Main function
main() {
    display_banner
    install_tools
    copy_script
    completion_message
}

# Run main function
main
