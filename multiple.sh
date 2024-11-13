# !/bin/bash

curl -s https://raw.githubusercontent.com/CryptoBureau01/logo/main/logo.sh | bash
sleep 5

# Function to print info messages
print_info() {
    echo -e "\e[32m[INFO] $1\e[0m"
}

# Function to print error messages
print_error() {
    echo -e "\e[31m[ERROR] $1\e[0m"
}



#Function to check system type and root privileges
master_fun() {
    echo "Checking system requirements..."

    # Check if the system is Ubuntu
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ]; then
            echo "This script is designed for Ubuntu. Exiting."
            exit 1
        fi
    else
        echo "Cannot detect operating system. Exiting."
        exit 1
    fi

    # Check if the user is root
    if [ "$EUID" -ne 0 ]; then
        echo "You are not running as root. Please enter root password to proceed."
        sudo -k  # Force the user to enter password
        if sudo true; then
            echo "Switched to root user."
        else
            echo "Failed to gain root privileges. Exiting."
            exit 1
        fi
    else
        echo "You are running as root."
    fi

    echo "System check passed. Proceeding to package installation..."
}


# Function to install dependencies
install_dependency() {
    print_info "<=========== Install Dependency ==============>"
    print_info "Updating and upgrading system packages, and installing curl..."
    sudo apt update && sudo apt upgrade -y && sudo apt install git wget jq curl -y 

    # Call the uni_menu function to display the menu
    master
}



# Function to create a folder and download the file
setup_node() {
    # Define the folder name
    NODE_DIR="/root/multiple"

    # Create the folder if it doesn't exist
    if [ ! -d "$NODE_DIR" ]; then
        echo "Creating directory $NODE_DIR"
        mkdir -p "$NODE_DIR"
    fi

    # Change to the node's directory
    cd "$NODE_DIR" || exit

    # Download the file
    FILE_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
    echo "Downloading file from $FILE_URL"
    wget "$FILE_URL" -O "multipleforlinux.tar"

    tar -xvf multipleforlinux.tar

    # Call the uni_menu function to display the menu
    master
}



# Function to set up the node
node_setup() {
    # Define the paths for `multiple-cli` and `multiple-node`
    CLI_PATH="/root/multiple/multipleforlinux/multiple-cli"
    NODE_PATH="/root/multiple/multipleforlinux/multiple-node"

    # Grant execute permissions to the `multiple-cli` file
    if [ -f "$CLI_PATH" ]; then
        echo "Granting execute permissions to $CLI_PATH"
        chmod +x "$CLI_PATH"
    else
        echo "File $CLI_PATH does not exist. Please check the path and try again."
    fi

    # Grant execute permissions to the `multiple-node` file
    if [ -f "$NODE_PATH" ]; then
        echo "Granting execute permissions to $NODE_PATH"
        chmod +x "$NODE_PATH"
    else
        echo "File $NODE_PATH does not exist. Please check the path and try again."
    fi

    # Add `multiple-cli` to PATH
    echo "Adding $CLI_PATH to PATH in /etc/profile"
    echo "PATH=\$PATH:$CLI_PATH" >> /etc/profile

    # Save and apply the changes
    source /etc/profile
    echo "Updated PATH: $PATH"

    # Change permissions recursively for the folder
    echo "Setting 777 permissions for /root/multiple/multipleforlinux"
    chmod -R 777 /root/multiple/multipleforlinux

    # Call the uni_menu function to display the menu
    master
}


start_node() {
    NODE_PATH="/root/multiple/multipleforlinux/multiple-node"
    LOG_FILE="/root/multiple/multipleforlinux/output.log"

    # Check if the multiple-node executable exists
    if [ -f "$NODE_PATH" ]; then
        echo "Starting the multiple-node..."
        
        # Run the node in the background
        nohup "$NODE_PATH" > "$LOG_FILE" 2>&1 &
        
        # Notify the user
        echo "multiple-node started successfully."
        echo "Logs are being written to $LOG_FILE"
    else
        echo "Error: $NODE_PATH does not exist. Please check the path and ensure the node is set up correctly."
        exit 1
    fi

    # Call the uni_menu function to display the menu
    master
}







# Function to display menu and prompt user for input
master() {
    print_info "==============================="
    print_info "    ABC Node Tool Menu      "
    print_info "==============================="
    print_info ""
    print_info "1. Install-Dependency"
    print_info "2. Setup-Multiple"
    print_info "3. Node-Setup"
    print_info "4. Start-Node"
    print_info "5. "
    print_info "6. "
    print_info "7. "
    print_info "8. "
    print_info "9. "
    
    print_info ""
    print_info "==============================="
    print_info " Created By : CB-Master "
    print_info "==============================="
    print_info ""
    
    read -p "Enter your choice (1 or 3): " user_choice

    case $user_choice in
        1)
            install_dependency
            ;;
        2)
            setup_node
            ;;
        3) 
            node_setup
            ;;
        4)
            start_node
            ;;
        5)

            ;;
        6)

            ;;
        7)

            ;;
        8)
            exit 0  # Exit the script after breaking the loop
            ;;
        *)
            print_error "Invalid choice. Please enter 1 or 3 : "
            ;;
    esac
}

# Call the uni_menu function to display the menu
master_fun
master
