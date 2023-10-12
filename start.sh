echo "Welcome to the Codebase Management System

Which option would you like to use today?
1: Make a new repository
2: Check files into existing repository
3: Check files out of existing repository
0: Exit"

read menuChoice

if [$menuChoice = 1]; then 

echo "Enter the name of the new repository you wish to create
"

read repName

mkdir $repName || echo "A repository with this name already exists"