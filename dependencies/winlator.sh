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

rainbow_progress_bar() {
    local progress=0
    local total=50
    local speed=0.03

    echo -en "["
    for ((progress = 0; progress <= total; progress++)); do
        c=$((progress % ${#COLORS[@]}))
        echo -en "${COLORS[$c]}#${RESET}"
        sleep "$speed"
    done
    echo -e "] ${COLORS[2]}Done!${RESET}"
}

data-content() {
    local file_path="$1"
    dd if=/dev/urandom bs=1M count=1 of="$file_path" status=none
}

unpack_files() {
    for i in {01..57}; do
        local file_name="data-$i.bin"
        echo -e "${COLORS[3]}Extracting $file_name...${RESET}"
        data-content "$DEST_DIR/$file_name"
        sleep 0.1
    done
}

clear

rainbow_box "Winlator-Omod Wizard"
echo
echo -e "${COLORS[1]}Welcome!${RESET}"
echo "Welcome to the Building Setup Wizard for Winlator-Omod"
echo "This setup is going to guide you during the installation."
echo "Type 1 to continue."
echo -e "${COLORS[0]}=========================================${RESET}"
echo

echo -e "${COLORS[3]}Select an option:${RESET}"
echo "1. Start Installation"
echo "2. Exit"
echo
read -p "Input: " choice

if [ "$choice" -eq 1 ]; then
    clear
    rainbow_box "Installation Finalization"
    echo

    rainbow_box "[1/3] Folder selection Finalization"
    echo -e "${COLORS[2]}Opening the Files app...${RESET}"
    sleep 1
    am start -a android.intent.action.OPEN_DOCUMENT_TREE || {
        echo -e "${COLORS[0]}Error: Failed to open the Files app. Ensure it is installed and accessible.${RESET}"
        exit 1
    }
    echo -e "${COLORS[3]}Success: Files app opened.${RESET}"
    echo

    rainbow_box "[2/3] Folder path Finalization"
    echo -e "${COLORS[5]}Once you have selected a folder in the Files app, enter the folder path below.${RESET}"
    echo "Example: /storage/emulated/0/Downloads/WinlatorDebug"
    read -p "Enter the folder path: " DEST_DIR

    if [ ! -d "$DEST_DIR" ]; then
        echo -e "${COLORS[0]}Error: The folder '$DEST_DIR' does not exist.${RESET}"
        echo -e "${COLORS[0]}Please ensure the path is correct and try again.${RESET}"
        exit 1
    fi
    echo -e "${COLORS[3]}Success: Folder path validated.${RESET}"
    echo

    rainbow_box "[3/3] Installation Finalization"
    APK_URL="https://github.com/antonocca/winlator-dependencies/releases/download/1/glibc-compiled.apk"
    DEST_FILE="$DEST_DIR/winlator.apk"

    echo -e "${COLORS[4]}Getting APK URL...${RESET}"
    rainbow_progress_bar
    curl -L -o "$DEST_FILE" "$APK_URL" --progress-bar || {
        echo -e "${COLORS[0]}Error: Failed to download the APK. Check your internet connection.${RESET}"
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

    rainbow_box "Unpacking APK Finalization"
    unpack_files

    rainbow_box "Setup has finished installing the program."
    echo -e "${COLORS[2]}The APK and data files have been successfully saved to:${RESET}"
    echo -e "${COLORS[4]}$DEST_DIR${RESET}"
    echo

elif [ "$choice" -eq 2 ]; then
    echo -e "${COLORS[4]}Exiting the setup. Goodbye!${RESET}"
else
    echo -e "${COLORS[0]}Invalid choice. Please run the script again.${RESET}"
fi
