declare -A projects
current_repo=""
choice=""

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
            add_file
            ;;
          4)
            remove_file
            ;;
          5)
            edit_file
            ;;
          6)
            check_files
            ;;
          7)
            list_contents
            ;;
          8)
            switch_repo
            ;;
          9)
            if [ -n "$current_repo" ]; then
                log_activity "Exiting..."
            fi
            echo "Exiting...";
            exit 0
            ;;
          *)
            echo "Invalid choice. Choose again."
            ;;
     esac
done
