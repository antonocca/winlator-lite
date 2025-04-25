#!/bin/bash


termux-setup-storage

COLORS=("\033[1;31m" "\033[1;33m" "\033[1;32m" "\033[1;36m" "\033[1;34m" "\033[1;35m")
RESET="\033[0m"

rainbow_box() {
    local text="$1"
    local border="========================================="
    echo -e "${COLORS[0]}$border${RESET}"
    for ((i = 0; i < ${#text}; i++)); do
        c=$((i % ${#COLORS[@]}))
        echo -en "${COLORS[$c]}${text:$i:1}${RESET}"
    done
    echo
    echo -e "${COLORS[0]}$border${RESET}"
}


clear


rainbow_box "antonocca winlator installer"
echo
echo -e "${COLORS[1]}Instructions:${RESET}"
echo "1. After selecting 'Install', the Files app will open."
echo "2. Select the folder where you want the APK to be saved."
echo "3. The script will download the APK to the selected folder."
echo -e "${COLORS[0]}=========================================${RESET}"
echo


echo -e "${COLORS[3]}Select an option:${RESET}"
echo "1. Install"
echo "2. Exit"
echo
read -p "Enter your choice: " choice


if [ "$choice" -eq 1 ]; then
    clear
    rainbow_box "Winlator Installation Log"
    echo

    
    rainbow_box "[1/5] Open Files App for Folder Selection"
    echo -e "${COLORS[2]}Opening the Files app...${RESET}"
    sleep 1
    am start -a android.intent.action.OPEN_DOCUMENT_TREE || {
        echo -e "${COLORS[0]}Error: Failed to open the Files app. Ensure it is installed and accessible.${RESET}"
        exit 1
    }
    echo -e "${COLORS[3]}Success: Files app opened.${RESET}"
    echo

    
    rainbow_box "[2/5] Select Folder and Enter Path"
    echo -e "${COLORS[5]}Once you have selected a folder in the Files app, enter the folder path below.${RESET}"
    echo "Example: /storage/emulated/0/Downloads/Winlator"
    read -p "Enter the folder path: " DEST_DIR

    
    if [ ! -d "$DEST_DIR" ]; then
        echo -e "${COLORS[0]}Error: The folder '$DEST_DIR' does not exist.${RESET}"
        echo -e "${COLORS[0]}Please ensure the path is correct and try again.${RESET}"
        exit 1
    fi
    echo -e "${COLORS[3]}Success: Folder path validated.${RESET}"
    echo

    
    rainbow_box "[3/5] Download Winlator APK"
    echo -e "${COLORS[2]}Downloading APK...${RESET}"
    sleep 1
    APK_URL="https://github.com/antonocca/winlator-dependencies/releases/download/1/glibc-compiled.apk"
    DEST_FILE="$DEST_DIR/winlator.apk"
    curl -L -o "$DEST_FILE" "$APK_URL" --progress-bar || {
        echo -e "${COLORS[0]}Error: Failed to download the APK. Check the URL and your internet connection.${RESET}"
        exit 1
    }

    
    FILE_SIZE=$(stat -c%s "$DEST_FILE")
    if [ "$FILE_SIZE" -lt 1024 ]; then
        echo -e "${COLORS[0]}Error: The downloaded file is too small and might be corrupted.${RESET}"
        echo -e "${COLORS[0]}File size: $FILE_SIZE bytes.${RESET}"
        rm "$DEST_FILE"
        exit 1
    fi
    echo -e "${COLORS[3]}Success: APK downloaded to $DEST_FILE.${RESET}"
    echo

    
    rainbow_box "[4/5] Ask User to Install APK"
    echo -e "${COLORS[4]}Do you want to install the APK directly from Termux? (yes/no)${RESET}"
    read -p "Enter your choice: " install_choice
    if [[ "$install_choice" == "yes" || "$install_choice" == "y" ]]; then
        rainbow_box "[5/5] Install APK"
        echo -e "${COLORS[2]}Installing APK...${RESET}"
        sleep 1
        termux-open "$DEST_FILE" || {
            echo -e "${COLORS[0]}Error: Failed to open the APK. Ensure a package manager is installed.${RESET}"
            exit 1
        }
        echo -e "${COLORS[3]}Success: APK installation triggered.${RESET}"
    else
        echo -e "${COLORS[1]}Installation skipped. You can manually open the APK later from $DEST_FILE.${RESET}"
    fi
elif [ "$choice" -eq 2 ]; then
    echo -e "${COLORS[4]}Exiting the installer.${RESET}"
else
    echo -e "${COLORS[0]}Invalid choice. Please run the script again.${RESET}"
fi
