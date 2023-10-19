#!/bin/bash

declare -A projects
current_repo=""
choice=""

function load_existing_repos {
    for d in */ ; do
        repo_name=$(basename "$d")
        projects["$repo_name"]="$repo_name"
    done
    echo "Loaded existing repositories."
}

load_existing_repos

function menu {
    echo "___________________________________________________________________________________________________________"
    echo "1. Create new project repository (last created will be set as current repository)"
    echo "2. Delete project repository"
    echo "3. Go to/Switch to project repository"
    echo "4. Show existing repositories"
    echo "5. Add file to the current project repository"
    echo "6. Remove file from the current project repository"
    echo "7. Check in/out files from current project repository"
    echo "8. List contents of current repository"
    echo "9. Show the log"
    echo "10. Rollback file to a previous version"
    echo "11. Archive current repository"
    echo "12. Access existing archive"
    echo "13. Exit"
    echo "___________________________________________________________________________________________________________"
    read -p "Enter your choice: " choice
}

# Existing functions

function create_repo {
    read -p "Enter the names of the project repositories (comma-separated): " names_input
    IFS=',' read -ra names <<< "$names_input"
    
    for name in "${names[@]}"; do
        trimmed_name=$(echo "$name" | xargs)
        mkdir "$trimmed_name"
        projects["$trimmed_name"]="$trimmed_name"
        echo "Repository '$trimmed_name' created."
    done
    
    current_repo="$trimmed_name"
}

function delete_repo {
    echo "These are the available repositories:"
    for repo in "${!projects[@]}"; do
       echo "$repo"
    done

    read -p "Enter the names of the project repositories to delete (comma-separated): " repos_input
    IFS=',' read -ra repos <<< "$repos_input"
    
    for repo in "${repos[@]}"; do
        trimmed_repo=$(echo "$repo" | xargs)
        
        if [[ -d "$trimmed_repo" && "${projects[$trimmed_repo]}" ]]; then
            rm -r "$trimmed_repo"
            unset projects["$trimmed_repo"]
            if [ "$current_repo" == "$trimmed_repo" ]; then
                current_repo=""
            fi
            echo "Repository '$trimmed_repo' deleted."
        else
            echo "Repository '$trimmed_repo' does not exist."
        fi
    done
}

function add_file {
    read -p "Enter the file names to add (comma-separated): " files_input
    IFS=',' read -ra files <<< "$files_input"
    
    for file in "${files[@]}"; do
        trimmed_file=$(echo "$file" | xargs)
        touch "$current_repo/$trimmed_file"
        echo "File '$trimmed_file' added to '$current_repo'."
    done
}

function remove_file {
    read -p "Enter the file names to remove (comma-separated): " files_input
    IFS=',' read -ra files <<< "$files_input"
    
    for file in "${files[@]}"; do
        trimmed_file=$(echo "$file" | xargs)
        if [ -f "$current_repo/$trimmed_file" ]; then
            rm "$current_repo/$trimmed_file"
            echo "File '$trimmed_file' removed from '$current_repo'."
        else
            echo "File '$trimmed_file' not found in '$current_repo'."
        fi
    done
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
       chmod -w "$current_repo/$file"
       echo "Checked in '$file'."
    elif [ "$action" == "2" ]; then
       chmod +w "$current_repo/$file"
       echo "Checked out '$file'."
    else
       echo "Invalid choice."
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

function show_repo {
    echo "These are the available repositories:"
    for repo in "${!projects[@]}"; do
       echo "$repo"
    done
}

function switch_repo {
    echo "These are the available repositories:"
    for repo in "${!projects[@]}"; do
       echo "$repo"
    done
    read -p "Enter the name of the project repository to switch to: " name
    if [[ -d "$name" && "${projects[$name]}" ]]; then
       current_repo="$name"
       echo "Switched to '$name' repository."
    else
       echo "Repository '$name' does not exist."
    fi
}

function show_log {
    if [ -z "$current_repo" ]; then
       echo "No current repository selected."
       return
    fi

    echo "Files in '$current_repo' with logs:"
    ls "$current_repo" | grep ".log"

    read -p "Enter the name of the file (without .log extension) to view its log: " file

    if [ -f "$current_repo/$file.log" ]; then
       echo "Log for '$file':"
       cat "$current_repo/$file.log"
    else
       echo "No log available for '$file'."
    fi
}

# New functions for rollback and archive

function rollback_file {
    read -p "Enter the filename to rollback: " file
    if [ ! -f "$current_repo/$file" ]; then
       echo "File '$file' does not exist in '$current_repo'."
       return
    fi

    echo "Available versions:"
    ls "$current_repo" | grep "$file.version."

    read -p "Enter the version to rollback to (e.g., $file.version.1): " version_file

    if [ -f "$current_repo/$version_file" ]; then
       cp "$current_repo/$version_file" "$current_repo/$file"
       echo "Rolled back '$file' to '$version_file'."
    else
       echo "Version '$version_file' does not exist."
    fi
}

function archive_repo {
    read -p "Enter the archive format (tar/zip): " format
    if [ "$format" == "tar" ]; then
       tar -cvf "$current_repo.tar" "$current_repo/"
       echo "Archive '$current_repo.tar' created."
    elif [ "$format" == "zip" ]; then
       zip -r "$current_repo.zip" "$current_repo/"
       echo "Archive '$current_repo.zip' created."
    else
       echo "Invalid format."
    fi
}

function access_archive {
    echo "Available archives:"
    ls | grep -E "\.tar$|\.zip$"

    read -p "Enter the name of the archive to access: " archive

    if [ -f "$archive" ]; then
       if [[ "$archive" == *.tar ]]; then
          tar -tvf "$archive"
       elif [[ "$archive" == *.zip ]]; then
          unzip -l "$archive"
       else
          echo "Unsupported archive format."
       fi
    else
       echo "Archive '$archive' does not exist."
    fi
}

# Main loop for menu

while true; do
    menu
    case $choice in
         1)
           create_repo
           ;;
         2)
           delete_repo
           ;;
         3)
           switch_repo
           ;;
         4)
           show_repo
           ;;
         5)
           add_file
           ;;
         6)
           remove_file
           ;;
         7)
           check_files
           ;;
         8)
           list_contents
           ;;
         9)
           show_log
           ;;
         10)
           rollback_file
           ;;
         11)
           archive_repo
           ;;
         12)
           access_archive
           ;;
         13)
           echo "Exiting...";
           exit 0
           ;;
         *)
           echo "Invalid choice. Choose again."
           ;;
    esac
done
