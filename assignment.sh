declare -A projects
current_repo=""
choice=""
function menu {
     echo "1. Create a new project repository"
     echo "2. Delete a project repository"
     echo "3. Add file to the current project repository"
     echo "4. Remove file from the current project repository"
     echo "5. Check in/out files from current project repository"
     echo "6. List contents of current repository"
     echo "7. Switch project repository"
     echo "8. Exit"
     read -p "enter your choice: " choice
}

function create_repo {
     read -p "Enter the name of the project repository: " name
     mkdir "$name"
     projects["$name"]="$name"
     current_repo="$name"
     echo "Repository '$name' created."
     list_contents
}

function delete_repo {
     read -p "Enter the name of the project repository to delete: " name
     rm  -r "$name"
     unset projects["$name"]
     if [ "$current_repo" == "$name" ]; then
         current_repo=""
     fi
     echo "Repository '$name' deleted."
}

function add_file {
     read -p "Enter the file name to add: " file
     touch "$current_repo/$file"
     echo "File '$file' removed from '$current_repo'."
     list_contents
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
        current_date=$(date +"%Y-%m-%d %T")
        read -p "Enter optional notes: " notes 
        echo "$username checked in '$file' on $current_date. Notes: $notes" >> "$current_repo/$file.log"
        echo "Checked in '$file'."
     elif [ "$action" == "2" ]; then
        read -p "Enter your user name: " username
        current_date=$(date +"%Y-%m-%d %T")
        read -p "Enter optonal notes: " notes
        echo "$username checked out '$file' on $current_date. Notes: $notes" >> "$current_repo/$file.log"
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

function switch_repo {
     echo "These are the available repositories:"
     for repo in "${!projects[@]}"; do
        echo "$repo"
     done
     read -p "Enter the name of the project repository to switch to switch to: " name
     if [[ -d "$name" && "${projects[$nam]}" ]]; then
        current_repo="$name"
        echo "Switched to '$name' repository."
        list_contents
     else
        echo "Repository '$name' does not exist."
     fi
}

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
            check_file
            ;;
          6) 
            list_contents
            ;;
          7) 
            switch_repo
            ;;
          8) 
            echo "Existing..."; 
            exit 0
            ;;
          *) 
            echo "Invalid choice. Choose again.";;
     esac
done
