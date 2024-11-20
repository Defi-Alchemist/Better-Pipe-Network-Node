#!/bin/bash

logo="
██████  ███████ ███████ ██      █████  ██       ██████ ██   ██ ███████ ███    ███ ██ ███████ ████████ 
██   ██ ██      ██      ██     ██   ██ ██      ██      ██   ██ ██      ████  ████ ██ ██         ██    
██   ██ █████   █████   ██     ███████ ██      ██      ███████ █████   ██ ████ ██ ██ ███████    ██    
██   ██ ██      ██      ██     ██   ██ ██      ██      ██   ██ ██      ██  ██  ██ ██      ██    ██    
██████  ███████ ██      ██     ██   ██ ███████  ██████ ██   ██ ███████ ██      ██ ██ ███████    ██    
"

glowing_text() {
    local colors=("\033[1;31m" "\033[1;32m" "\033[1;33m" "\033[1;34m" "\033[1;35m" "\033[1;36m")
    for i in {1..5}; do
        color=${colors[$RANDOM % ${#colors[@]}]}
        echo -e "${color}$logo\033[0m"
        sleep 0.2
        clear
    done
}

perspective_shift() {
    local shift_angle=(" " "." ":" "|")
    for i in {1..10}; do
        for angle in "${shift_angle[@]}"; do
            clear
            echo -e "\033[1;37m$logo$angle\033[0m"
            sleep 0.2
        done
    done
}

color_gradient() {
    for i in {1..10}; do
        color_code=$((31 + (i % 6)))
        echo -e "\033[${color_code}m$logo\033[0m"
        sleep 0.4
        clear
    done
}

typewriter_effect() {
    local text="Defi Alchemist - See me on telegram ::   https://t.me/Theunforseen"
    for (( i=0; i<${#text}; i++ )); do
        echo -n -e "${text:i:1}"
        sleep 0.05
    done
    echo
}

random_line_move() {
    for i in {1..10}; do
        clear
        for j in {1..5}; do
            spaces=$((RANDOM % 10))
            line=$(echo "$logo" | sed -n "${j}p")
            printf "%${spaces}s%s\n" "" "$line"
        done
        sleep 0.2
    done
}

pixelated_glitch() {
    local glitch_text="$logo"
    local length=${#glitch_text}
    
    for i in {1..5}; do
        glitch_line=""
        for (( j=0; j<$length; j++ )); do
            if (( RANDOM % 5 == 0 )); then
                glitch_line="${glitch_line}\033[1;37m*\033[0m"
            else
                glitch_line="${glitch_line}${glitch_text:j:1}"
            fi
        done
        echo -e "$glitch_line"
        sleep 0.1
        clear
    done
}

machine_sounds() {
    for i in {1..3}; do
        echo -e "\a"
        sleep 0.3
        echo -e "\033[1;32m*Whirr* \033[0m"
        sleep 0.5
    done
}

progress_bar() {
    local progress=0
    echo -e "Loading... \033[1;34m["
    while [ $progress -le 100 ]; do
        sleep 0.1
        echo -n -e "\033[1;32m#\033[0m"
        ((progress+=5))
    done
    echo -e "]"
    sleep 0.5
}

clear
glowing_text
sleep 0.5
perspective_shift
sleep 0.5
color_gradient
sleep 0.5
typewriter_effect
sleep 0.5
random_line_move
sleep 0.5
pixelated_glitch
sleep 0.5
machine_sounds
sleep 0.5
progress_bar

clear

sudo apt update && sudo apt upgrade -y

dependencies=("curl" "jq")

for dependency in "${dependencies[@]}"; do
    if ! dpkg -l | grep -q "$dependency"; then
        echo "$dependency is not installed. Installing..."
        sudo apt install "$dependency " -y
    else
        echo "$dependency is already installed."
    fi
done

echo "Please enter your email:"
read -r email

echo "Please enter your password:"
read -s password

response=$(curl -s -X POST "https://pipe-network-backend.pipecanary.workers.dev/api/login" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"$email\", \"password\":\"$password\"}")

echo "Login response: $response"
echo "$(echo $response | jq -r .token)" > token.txt

log_file="node_operations.log"

fetch_ip_address() {
    ip_response=$(curl -s "https://api64.ipify.org?format=json")
    echo "$(echo $ip_response | jq -r .ip)"
}

fetch_geo_location() {
    ip=$1
    geo_response=$(curl -s "https://ipapi.co/${ip}/json/")
    echo "$geo_response"
}

send_heartbeat() {
    token=$(cat token.txt)
    username="your_username"
    ip=$(fetch_ip_address)
    geo_info=$(fetch_geo_location "$ip")

    heartbeat_data=$(jq -n --arg username "$username" --arg ip "$ip" --argjson geo_info "$geo_info" '{username: $username, ip: $ip, geo: $geo_info}')

    heartbeat_response=$(curl -s -X POST "https://pipe-network-backend.pipecanary.workers.dev/api/heartbeat" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d "$heartbeat_data")

    echo "Heartbeat response: $heartbeat_response" | tee -a "$log_file"
}

fetch_points() {
    token=$(cat token.txt)
    points_response=$(curl -s -X GET "https://pipe-network-backend.pipecanary.workers.dev/api/points" \
        -H "Authorization: Bearer $token")

    if echo "$points_response" | jq -e . >/dev/null 2>&1; then
        echo "User  Points Response: $points_response" | tee -a "$log_file"
    else
        echo "Error fetching points: $points_response" | tee -a "$log_file"
    fi
}

test_nodes() {
    token=$(cat token.txt)
    nodes_response=$(curl -s -X GET "https://pipe-network-backend.pipecanary.workers.dev/api/nodes" \
        -H "Authorization: Bearer $token")

    if [ -z "$nodes_response" ]; then
        echo "Error: No nodes found or failed to fetch nodes." | tee -a "$log_file"
        return
    fi

    for node in $(echo "$nodes_response" | jq -c '.[]'); do
        node_id=$(echo "$node" | jq -r .node_id)
        node_ip=$(echo "$node" | jq -r .ip)

        latency=$(test_node_latency "$node_ip")

        if [[ "$latency" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo "Node ID: $node_id, IP: $node_ip, Latency: ${latency}ms" | tee -a "$log_file"
        else
            echo "Node ID: $node_id, IP: $node_ip, Latency: Timeout/Error" | tee -a "$log_file"
        fi

        report_test_result "$node_id" "$node_ip" "$latency"
    done
}

test_node_latency() {
    node_ip=$1
    start=$(date +%s%3N)

    latency=$(curl -o /dev/null -s -w "%{time_total}\n" "http://$node_ip")

    if [ -z "$latency" ]; then
        return -1
    else
        echo $latency
    fi
}

report_test_result() {
    node_id=$1
    node_ip=$2
    latency=$3

    token=$(cat token.txt)

    if [ -z "$token" ]; then
        echo "Error: No token found. Skipping result reporting." | tee -a "$log_file"
        return
    fi

    if [[ "$latency" =~ ^[0-9]+(\.[0-9]+)?$ ]] && (( $(echo "$latency > 0" | bc -l) )); then
        status="online"
    else
        status="offline"
        latency=-1
    fi

    report_response=$(curl -s -X POST "https://pipe-network-backend.pipecanary.workers.dev/api/test" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type : application/json" \
        -d "{\"node_id\": \"$node_id\", \"ip\": \"$node_ip\", \"latency\": $latency, \"status\": \"$status\"}")

    if echo "$report_response" | jq -e . >/dev/null 2>&1; then
        echo "Reported result for node $node_id ($node_ip), status: $status" | tee -a "$log_file"
    else
        echo "Failed to report result for node $node_id ($node_ip)." | tee -a "$log_file"
    fi
}

while true; do
    fetch_points
    test_nodes
    send_heartbeat
    fetch_points
    sleep 300
done
