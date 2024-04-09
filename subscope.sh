#!/usr/bin/env bash

bold="\e[1m"
Underlined="\e[4m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
yellow="\e[33m"
end="\e[0m"
VERSION="2022-09-22"

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Validate required tools
validate_tools() {
    local tools=("curl" "awk" "sort" "tr" "grep" "sed" "findomain" "subfinder" "amass" "assetfinder")
    local success=true

    echo -e "${bold}${blue}===[ Validating Tools ]===${end}"
    for tool in "${tools[@]}"; do
        printf "${yellow}[*] Checking $tool ...${end}"
        if command_exists "$tool"; then
            echo -e "\r${green}[+] $tool is installed${end}"
        else
            echo -e "\r${red}[x] $tool is not installed${end}"
            success=false
        fi
    done

    if $success; then
        echo -e "${green}[+] All required tools are installed.${end}"
    else
        echo -e "${red}[!] Some required tools are missing.${end}"
    fi
    echo
}

# Check internet connectivity
check_internet() {
    echo -e "${bold}${blue}===[ Checking Internet Connectivity ]===${end}"
    printf "${yellow}[*] Checking internet connectivity ...${end}"
    if ping -q -c 1 -W 1 google.com >/dev/null; then
        echo -e "\r${green}[+] Internet connectivity is available.${end}"
    else
        echo -e "\r${red}[x] No internet connectivity.${end}"
        exit 1
    fi
    echo
}

# Display the banner for 3 seconds
show_banner() {
    clear
    echo ""
    echo ""
    echo ""
    echo -e "${bold}${green}  ██████  █    ██  ▄▄▄▄        ██████  ▄████▄   ▒█████   ██▓███  ▓█████    ${end}"
    echo -e "${bold}${green} ▒██    ▒  ██  ▓██▒▓█████▄    ▒██    ▒ ▒██▀ ▀█  ▒██▒  ██▒▓██░  ██▒▓█   ▀    ${end}"
    echo -e "${bold}${green} ░ ▓██▄   ▓██  ▒██░▒██▒ ▄██   ░ ▓██▄   ▒▓█    ▄ ▒██░  ██▒▓██░ ██▓▒▒███      ${end}"
    echo -e "${bold}${green}   ▒   ██▒▓▓█  ░██░▒██░█▀       ▒   ██▒▒▓▓▄ ▄██▒▒██   ██░▒██▄█▓▒ ▒▒▓█  ▄    ${end}"
    echo -e "${bold}${green} ▒██████▒▒▒▒█████▓ ░▓█  ▀█▓   ▒██████▒▒▒ ▓███▀ ░░ ████▓▒░▒██▒ ░  ░░▒████▒   ${end}"
    echo -e "${bold}${green} ▒ ▒▓▒ ▒ ░░▒▓▒ ▒ ▒ ░▒▓███▀▒   ▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░░ ▒░▒░▒░ ▒▓▒░ ░  ░░░ ▒░ ░   ${end}"
    echo -e "${bold}${green} ░ ░▒  ░ ░░░▒░ ░ ░ ▒░▒   ░    ░ ░▒  ░ ░  ░  ▒     ░ ▒ ▒░ ░▒ ░      ░ ░  ░   ${end}"
    echo -e "${bold}${green} ░  ░  ░   ░░░ ░ ░ ░    ░    ░  ░  ░  ░        ░ ░ ░ ▒  ░░          ░       ${end}"
    echo -e "${bold}${green}       ░     ░      ░               ░  ░ ░          ░ ░              ░  ░    ${end}"
    echo -e "${bold}${red}                      DEvELoPeD By Sdx - SaGaR DhEkLe                             ${end}"
    echo
    sleep 3
}

# Save subdomains to a file
save_subdomains_to_file() {
    local output_file="${domain}_subdomains.txt"
    echo -e "${bold}${blue}===[ Saving Subdomains to File ]===${end}"
    echo -e "${yellow}[*] Saving subdomains to ${output_file} ...${end}"
    echo "$subdomains" > "$output_file"
    echo -e "${green}[+] Subdomains saved to ${output_file}.${end}"
}

l_usage(){
    echo -e "${bold}${blue}Usage:${end} $0 -d <domain>"
    echo -e "${bold}${blue}Options:${end}"
    echo -e "  -d, --domain       Domain to enumerate subdomains"
    echo -e "  -h, --help         Display this help message and exit"
    echo -e "  -v, --version      Display the version and exit"
    exit 1
}

l_main() {
    show_banner
    validate_tools
    check_internet

    if [ -z "$domain" ]; then
        echo -e "${red}[!] Domain argument is required.${end}"
        l_usage
        exit 1
    fi

    echo -e "${bold}${Underlined}Domain:${end} $domain"
    echo

    echo -e "${bold}${blue}===[ Subdomains Found ]===${end}"
    echo

    echo -e "${bold}${blue}===[ Using Web Archive ]===${end}"
    web_archive=$(curl -sk "http://web.archive.org/cdx/search/cdx?url=*.$domain&output=txt&fl=original&collapse=urlkey&page=" | awk -F/ '{gsub(/:.*/, "", $3); print $3}' | sort -u)
    [ -n "$web_archive" ] && echo "$web_archive" || echo "No subdomains found using Web Archive"
    echo

    echo -e "${bold}${blue}===[ Using CRT.SH ]===${end}"
    crtsh=$(curl -sk "https://crt.sh/?q=%.$domain&output=json" | tr ',' '\n' | awk -F'"' '/name_value/ {gsub(/\*\./, "", $4); gsub(/\\n/,"\n",$4);print $4}' | sort -u)
    [ -n "$crtsh" ] && echo "$crtsh" || echo "No subdomains found using CRT.SH"
    echo

    echo -e "${bold}${blue}===[ Using AbuseIPDB ]===${end}"
    abuseipdb=$(curl -s "https://www.abuseipdb.com/whois/$domain" -H "user-agent: firefox" -b "abuseipdb_session=" | grep -E '<li>\w.*</li>' | sed -E 's/<\/?li>//g' | sed -e "s/$/.$domain/")
    [ -n "$abuseipdb" ] && echo "$abuseipdb" || echo "No subdomains found using AbuseIPDB"
    echo

    echo -e "${bold}${blue}===[ Using DNS Bufferover ]===${end}"
    dns_bufferover=$(curl -s "https://dns.bufferover.run/dns?q=.$domain" | grep $domain | awk -F, '{gsub("\"", "", $2); print $2}')
    [ -n "$dns_bufferover" ] && echo "$dns_bufferover" || echo "No subdomains found using DNS Bufferover"
    echo

    echo -e "${bold}${blue}===[ Using Findomain ]===${end}"
    findomain=$(findomain -t $domain -q 2>/dev/null)
    [ -n "$findomain" ] && echo "$findomain" || echo "No subdomains found using Findomain"
    echo

    echo -e "${bold}${blue}===[ Using Subfinder ]===${end}"
    subfinder=$(subfinder -all -silent -d $domain 2>/dev/null)
    [ -n "$subfinder" ] && echo "$subfinder" || echo "No subdomains found using Subfinder"
    echo

    echo -e "${bold}${blue}===[ Using Amass ]===${end}"
    amass=$(amass enum -passive -norecursive -noalts -d $domain 2>/dev/null)
    [ -n "$amass" ] && echo "$amass" || echo "No subdomains found using Amass"
    echo

    echo -e "${bold}${blue}===[ Using Assetfinder ]===${end}"
    assetfinder=$(assetfinder --subs-only $domain)
    [ -n "$assetfinder" ] && echo "$assetfinder" || echo "No subdomains found using Assetfinder"
    
s
}

# Parse command-line options
while getopts ":d:hv" opt; do
    case ${opt} in
        d)
            domain=$OPTARG
            ;;
        h)
            l_usage
            ;;
        v)
            echo "Version: $VERSION"
            exit 0
            ;;
        \?)
            echo "Invalid option: $OPTARG" 1>&2
            l_usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." 1>&2
            l_usage
            ;;
    esac
done
shift $((OPTIND -1))

l_main
