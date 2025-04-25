#!/bin/bash

# 
termux-setup-storage

# 
COLORS=("\033[1;31m" "\033[1;33m" "\033[1;32m" "\033[1;36m" "\033[1;34m" "\033[1;35m")
RESET="\033[0m"

# 
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

# 
rainbow_progress_bar() {
    local progress=0
    local total=50  # 
    local speed=0.05  # 

    rainbow_box "Unpacking APK"
    echo -en "["
    for ((progress = 0; progress <= total; progress++)); do
        c=$((progress % ${#COLORS[@]}))
        echo -en "${COLORS[$c]}#${RESET}"
        sleep "$speed"
    done
    echo -e "] ${COLORS[2]}Done!${RESET}"
}

# 
clear

# 
rainbow_box "winlator setup by antonocca"
echo
echo -e "${COLORS[1]}Instructions:${RESET}"
echo "1. After selecting 'Install', the Files app will open."
echo "2. Select the folder where you want the APK to be saved."
echo "3. The script will download the APK to the selected folder."
echo -e "${COLORS[0]}=========================================${RESET}"
echo

# 
echo -e "${COLORS[3]}Select an option:${RESET}"
echo "1. Install"
echo "2. Exit"
echo
read -p "Enter your choice: " choice

# 
if [ "$choice" -eq 1 ]; then
    clear
    rainbow_box "Console"
    echo

    # 
    rainbow_box "[1/4] Open Files App for Folder Selection"
    echo -e "${COLORS[2]}Opening the Files app...${RESET}"
    sleep 1
    am start -a android.intent.action.OPEN_DOCUMENT_TREE || {
        echo -e "${COLORS[0]}Error: Failed to open the Files app. Ensure it is installed and accessible.${RESET}"
        exit 1
    }
    echo -e "${COLORS[3]}Success: Files app opened.${RESET}"
    echo

    # 
    rainbow_box "[2/4] Select Folder and Enter Path"
    echo -e "${COLORS[5]}Once you have selected a folder in the Files app, enter the folder path below.${RESET}"
    echo "Example: /storage/emulated/0/Downloads/WinlatorDebug"
    read -p "Enter the folder path: " DEST_DIR

    # 
    if [ ! -d "$DEST_DIR" ]; then
        echo -e "${COLORS[0]}Error: The folder '$DEST_DIR' does not exist.${RESET}"
        echo -e "${COLORS[0]}Please ensure the path is correct and try again.${RESET}"
        exit 1
    fi
    echo -e "${COLORS[3]}Success: Folder path validated.${RESET}"
    echo

    # 
    rainbow_box "[3/4] Download Winlator APK"
    echo -e "${COLORS[2]}Downloading APK...${RESET}"
    sleep 1
    APK_URL="https://github.com/antonocca/winlator-lite/releases/download/omod-glibc-v10.2s/glibc-compiled.apk"
    DEST_FILE="$DEST_DIR/winlator.apk"
    curl -L -o "$DEST_FILE" "$APK_URL" --progress-bar || {
        echo -e "${COLORS[0]}Error: Failed to download the APK. Check the URL and your internet connection.${RESET}"
        exit 1
    }

    # 
    FILE_SIZE=$(stat -c%s "$DEST_FILE")
    if [ "$FILE_SIZE" -lt 1024 ]; then
        echo -e "${COLORS[0]}Error: The downloaded file is too small and might be corrupted.${RESET}"
        echo -e "${COLORS[0]}File size: $FILE_SIZE bytes.${RESET}"
        rm "$DEST_FILE"
        exit 1
    fi
    echo -e "${COLORS[3]}Success: APK downloaded to $DEST_FILE.${RESET}"
    echo

    # 
    rainbow_progress_bar

    #
    rainbow_box "[4/4] APK Download Complete"
    echo -e "${COLORS[2]}The APK has been successfully downloaded to:${RESET}"
    echo -e "${COLORS[4]}$DEST_FILE${RESET}"
    echo

elif [ "$choice" -eq 2 ]; then
    echo -e "${COLORS[4]}Exiting the downloader. Goodbye!${RESET}"
else
    echo -e "${COLORS[0]}Invalid choice. Please run the script again.${RESET}"
fi
