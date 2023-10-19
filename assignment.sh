declare -A projects
current_repo=""
choice=""

<<<<<<< Updated upstream
# Function to log activities
function log_activity {
    if [ -n "$current_repo" ]; then
        echo "$1" >> "$current_repo/log.txt"
    fi
}

function menu {
     echo "1. Create a new project repository"
     echo "2. Delete a project repository"
     echo "3. Add file to the current project repository"
     echo "4. Remove file from the current project repository"
     echo "5. Edit file in the current project repository"
     echo "6. Check in/out files from current project repository"
     echo "7. List contents of current repository"
     echo "8. Switch project repository"
     echo "9. Exit"
     read -p "enter your choice: " choice
}

function create_repo {
     read -p "Enter the name of the project repository: " name
     mkdir "$name"
     touch "$name/log.txt"
     projects["$name"]="$name"
     current_repo="$name"
     log_activity "Repository '$name' created."
     echo "Repository '$name' created."
     list_contents
}

function delete_repo {
     read -p "Enter the name of the project repository to delete: " name
     rm -r "$name"
     unset projects["$name"]
     log_activity "Repository '$name' deleted."
     echo "Repository '$name' deleted."
}

function add_file {
     if [ -z "$current_repo" ]; then
        echo "No current repository selected."
        return
     fi
     read -p "Enter the file name to add: " file
     touch "$current_repo/$file"
     log_activity "File '$file' added."
     echo "File '$file' added."
     list_contents
}

function edit_file {
     if [ -z "$current_repo" ]; then
        echo "No current repository selected."
        return
     fi
     read -p "Enter the file name to edit: " file
     nano "$current_repo/$file"
     log_activity "File '$file' edited."
     echo "File '$file' edited."
     list_contents
}

# ... (other existing functions)
=======
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

# ... Your existing functions here ...

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
>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
            add_file
            ;;
          4)
            remove_file
            ;;
          5)
            edit_file
            ;;
          6)
=======
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
>>>>>>> Stashed changes
            check_files
            ;;
          7)
            list_contents
            ;;
          8)
            switch_repo
            ;;
<<<<<<< Updated upstream
          9)
            if [ -n "$current_repo" ]; then
                log_activity "Exiting..."
            fi
=======
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
>>>>>>> Stashed changes
            echo "Exiting...";
            exit 0
            ;;
          *)
            echo "Invalid choice. Choose again."
            ;;
     esac
done
