#!/bin/bash
declare -A projects
current_repo=""
choice=""

function menu {
    echo "1. Create a new project repository"
    echo "2. Delete a project repository"
    echo "3. Add file to the current project repository"
    echo "4. Remove file from the current project repository"
    echo "5. Edit a file in the current project repository"
    echo "6. Check in/out files from current project repository"
    echo "7. List contents of current repository"
    echo "8. Switch project repository"
    echo "9. Exit"
    read -p "Enter your choice: " choice
}

function create_repo {
    read -p "Enter the name of the project repository: " name
    mkdir "$name"
    projects["$name"]="$name"
    current_repo="$name"
    echo "[$(date +\"%Y-%m-%d %T\")] Repository '$name' created." >> "$name/actions.log"
    list_contents
}

function delete_repo {
    read -p "Enter the name of the project repository to delete: " name
    rm -r "$name"
    unset projects["$name"]
    if [ "$current_repo" == "$name" ]; then
        current_repo=""
    fi
    echo "[$(date +\"%Y-%m-%d %T\")] Repository '$name' deleted." >> "$name/actions.log"
}

function add_file {
    read -p "Enter the file name to add: " file
    touch "$current_repo/$file"
    echo "[$(date +\"%Y-%m-%d %T\")] File '$file' added to '$current_repo'." >> "$current_repo/actions.log"
    list_contents
}

function remove_file {
    read -p "Enter the file name to remove: " file
    rm "$current_repo/$file"
    echo "[$(date +\"%Y-%m-%d %T\")] File '$file' removed from '$current_repo'." >> "$current_repo/actions.log"
    list_contents
}

function edit_file {
    read -p "Enter the file name to edit: " file
    nano "$current_repo/$file"
    echo "[$(date +\"%Y-%m-%d %T\")] File '$file' edited in '$current_repo'." >> "$current_repo/actions.log"
}

function check_files {
    read -p "Enter filename to check in/out: " file
    if [ ! -f "$current_repo/$file" ]; then
        echo "File '$file' does not exist in '$current_repo'."
        return
    fi

    echo "1. Check in"
    echo "2. Check out"
    read -p "Choose an action (1/2): " action

    if [ "$action" == "1" ]; then
        read -p "Enter your username: " username
        current_date=$(date +\"%Y-%m-%d %T\")
        read -p "Enter optional notes: " notes 
        echo "$username checked in '$file' on $current_date. Notes: $notes" >> "$current_repo/$file.log"
        echo "Checked in '$file'." >> "$current_repo/actions.log"
    elif [ "$action" == "2" ]; then
        read -p "Enter your username: " username
        current_date=$(date +\"%Y-%m-%d %T\")
        read -p "Enter optional notes: " notes
        echo "$username checked out '$file' on $current_date. Notes: $notes" >> "$current_repo/$file.log"
        echo "Checked out '$file'." >> "$current_repo/actions.log"
    else
        echo "Invalid choice." >> "$current_repo/actions.log"
    fi
}

function list_contents {
    if [ -n "$current_repo" ]; then
        echo "Contents of '$current_repo' repository:"
        ls "$current_repo"
    else
        echo "No current repository selected."
    fi
}

function switch_repo {
    echo "These are the available repositories:"
    for repo in "${!projects[@]}"; do
        echo "$repo"
    done
    read -p "Enter the name of the project repository to switch to: " name
    if [[ -d "$name" && "${projects[$name]}" ]]; then
        current_repo="$name"
        echo "Switched to '$name' repository." >> "$current_repo/actions.log"
        list_contents
    else
        echo "Repository '$name' does not exist."
    fi
}

while true; do
    menu
    case $choice in
        1) create_repo;;
        2) delete_repo;;
        3) add_file;;
        4) remove_file;;
        5) edit_file;;
        6) check_files;;
        7) list_contents;;
        8) switch_repo;;
        9) echo "[$(date +\"%Y-%m-%d %T\")] Exiting..."; exit 0;;
        *) echo "Invalid choice. Choose again.";;
    esac
done
