# Declare an associative array to store project repositories
declare -A projects
current_repo="" # The currently selected project repository
choice=""       # The user's choice in the menu
backup_dir="backup" # Directory to store backup files

# Create the backup directory if it does not exist
if [ ! -d "$backup_dir" ]; then
    mkdir "$backup_dir"
fi

# Load existing project repositories into the 'projects' array
function load_existing_repos {
    for d in */ ; do
        repo_name=$(basename "$d")
        projects["$repo_name"]="$repo_name"
    done
    echo "Loaded existing repositories."
}
load_existing_repos

#Displays menu
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
     echo "10. Restore the edited/deleted files"
     echo "11. Exit"
     echo "___________________________________________________________________________________________________________"
     read -p "enter your choice: " choice
}

# Create new project repository
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
    list_contents
}

# Delete a project repository
function delete_repo {
     read -p "Enter the names of the project repositories to delete (comma-separated): " repos_input
     IFS=',' read -ra repos <<< "$repos_input"
     
     for repo in "${repos[@]}"; do
         trimmed_repo=$(echo "$repo" | xargs)  # Trim whitespaces
         
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

# Add a new file to the current repository
function add_file {
    read -p "Enter the file names to add (comma-separated): " files_input
    IFS=',' read -ra files <<< "$files_input"
    
    for file in "${files[@]}"; do
        trimmed_file=$(echo "$file" | xargs)  # Trim whitespaces
        touch "$current_repo/$trimmed_file"
        echo "File '$trimmed_file' added to '$current_repo'."
    done
    
    list_contents
}

# Remove a file from the current repository and back it up
function remove_file {
     if [ -n "$current_repo" ]; then
        echo "Contents of '$current_repo' repository:"
        ls "$current_repo"
     else
        echo "No current repository selected."
     fi

    read -p "Enter the file names to remove (comma-separated): " files_input
    IFS=',' read -ra files <<< "$files_input"
    
    for file in "${files[@]}"; do
        trimmed_file=$(echo "$file" | xargs)  # Trim whitespaces
        if [ -f "$current_repo/$trimmed_file" ]; then
            backup_file "$current_repo" "$trimmed_file"
            rm "$current_repo/$trimmed_file"
            echo "File '$trimmed_file' deleted from '$current_repo'."
        else
            echo "File '$trimmed_file' not found in '$current_repo'."
        fi
    done
    
    list_contents
}

# Check files in or out of the current repository
function check_files {
     read -p "Enter filename to check in/out: " file
     if [ ! -f "$current_repo/$file" ]; then
        echo "File '$file' does not exist in '$current_repo'."
        return
     fi
     
     backup_file "$current_repo" "$file"

     echo "1. Check in"
     echo "2. Check out"
     read -p "Choose an action (1/2): " action

     if [ "$action" == "1" ]; then
        chmod -w "$current_repo/$file"
        read -p "Enter your username: " username
        current_date=$(date +"%Y-%m-%d %T")
        read -p "Enter optional notes: " notes 
        echo "$username checked in '$file' on $current_date. Notes: $notes" >> "$current_repo/$file.log"
        echo "Checked in '$file'."
     elif [ "$action" == "2" ]; then
        chmod +w "$current_repo/$file"
        nano "$current_repo/$file"
        read -p "Enter your user name: " username
        current_date=$(date +"%Y-%m-%d %T")
        read -p "Enter optonal notes: " notes
        echo "$username checked out '$file' on $current_date. Notes: $notes" >> "$current_repo/$file.log"
        echo "Checked out '$file'."
     else
        echo "Invalid choice."
     fi
}
 
# Display the contents of the current repository
function list_contents {
     if [ -n "$current_repo" ]; then
        echo "Contents of '$current_repo' repository:"
        ls "$current_repo"
     else
        echo "No current repository selected."
     fi
}

# Display the names of existing repositories
function show_repo {
      echo "These are the available repositories:"
     for repo in "${!projects[@]}"; do
        echo "$repo"
     done
}
  
# Switch to a different project repository
function switch_repo {
     echo "These are the available repositories:"
     for repo in "${!projects[@]}"; do
        echo "$repo"
     done
     read -p "Enter the name of the project repository to switch to switch to: " name
     if [[ -d "$name" && "${projects[$name]}" ]]; then
        current_repo="$name"
        echo "Switched to '$name' repository."
        list_contents
     else
        echo "Repository '$name' does not exist."
     fi
}


# Display the log for a file in the current repository
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
 
# Backup a file
function backup_file {
    local repo=$1
    local file=$2
    if [ -f "$repo/$file" ]; then
        cp "$repo/$file" "$backup_dir/${repo}_$file"
    fi
}

# Restore a file from backup
function restore_backup {
    echo "List of backed up files for repositories:"
    ls "$backup_dir" | grep "${current_repo}_"
    
    read -p "Enter the name of the file (without ${current_repo}_ prefix) to restore: " file
    
    if [ -f "$backup_dir/${current_repo}_$file" ]; then
        cp "$backup_dir/${current_repo}_$file" "$current_repo/$file"
        echo "File '$file' restored to '$current_repo'."
    else
        echo "No backup available for '$file'."
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
            restore_backup
            ;;
          11) 
            echo "Exiting..."; 
            exit 0
            ;;
          *) 
            echo "Invalid choice. Choose again.";;
     esac
done
