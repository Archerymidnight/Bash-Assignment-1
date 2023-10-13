#!/bin/bash

add_file () {
    touch "$1"
    cd ..
}

log_entry () {

    if ! [ -d "log.txt" ]
    then
        touch "log.txt"

    fi


    date >> "log.txt"
    echo "Please enter the details of your edit"

    read logText

    echo "$logText" >> "log.txt"

    
}

valid_login () {
    local input="testLogins.txt"
    while read -r line
    do
        IFS=' ' read -ra loginArray <<< "$line" 

        if [ "${loginArray[0]}" = "$1" ]
        then
            if [ "${loginArray[1]}" = "$2" ]
            then
                return 1
            fi
        else
            return 0
        fi
    done < "$input"
}

echo "Please enter your username"
read username
echo "Please enter your password"
read password

validLogin=valid_login "$username" "$password"

if [ "$validLogin" ]
then
        

    while true; do 


        echo "Welcome to the Codebase Management System

        Which option would you like to use today?
        1: Make a new repository
        2: Check files into existing repository
        3: Check files out of existing repository
        0: Exit"

        read menuChoice

        if [ "$menuChoice" = 1 ]
        then 

            echo "Enter the name of the new repository you wish to create
            "

            read repName

            mkdir "$repName" 2>/dev/null || echo "A repository with this name already exists"

            if [ -d "$repName" ]
            then

                echo "Enter the name of the initial file for the repository"

                read fileName

                add_file "$fileName"

                while true; do

                    echo "Do you wish to add another file? Y/N"

                    read newFileChoice

                    if [ "${newFileChoice^^}" = 'Y' ]
                    then
                        echo "Enter the name of the new file"

                        read fileName

                        add_file "$fileName"
                    elif [ "${newFileChoice^^}" == "N" ]
                    then
                        chgrp -R checkout "$repName"
                        chmod -R 770 "$repName"
                        break
                    
                    else
                    echo "Invalid input, please try again

                    "

                    fi
                done
            fi

        elif [ "$menuChoice" = 2 ]
        then


        elif [ "$menuChoice" = 3 ]
        then

        

        elif [ "$menuChoice" = 0 ]
        then
            valid_login
            exit

        fi

    done
else
    echo "Invalid credentials. Try again"
