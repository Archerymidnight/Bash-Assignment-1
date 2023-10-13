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

    "$username" >> "log.txt"
    date >> "log.txt"
    echo "Please enter the details of your edit"

    read logText

    logText="${logText}\n"

    echo "$logText" >> "log.txt"

    
}


echo "Please enter your username"
read username

isValidUser=$(cmd < testLogins.txt | grep -c "$username")

if [ "$isValidUser" -eq 1 ]
then
    

    while true; do 


        echo "Welcome to the Codebase Management System $username

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
            cd testRepo

            echo "Which file do you wish to check out?"

            ls 

            read checkoutChoice

            if test -f "$checkoutChoice"
            then
                isCheckedOut=$(cmd < ../checkedout.txt | grep -c "$checkoutChoice")

                if [ "$isCheckedOut" -eq 0 ]
                then
                    chmod 777 "$checkoutChoice"
                    echo "{$username} {$checkoutChoice}" >> ../checkedout.txt
                    nano "$checkoutChoice"
                fi
            fi

        elif [ "$menuChoice" = 3 ]
        then
            cd testRepo

            echo "Which file do you wish to check in? You can only check in a file YOU checked out"

            ls
            
            read checkinChoice

            if test -f "$checkinChoice"
            then
                youCheckedOut=$(cmd < ../checkedout.txt | grep -c "{$username} {$checkinChoice}")

                if [ "$youCheckedOut" -eq 1 ]
                then
                    chmod 770 "$checkinChoice"
                    grep -v "$checkinChoice" checkedout.txt > temp && mv temp checkedout.txt
                fi
            fi

        elif [ "$menuChoice" = 0 ]
        then
            exit

        fi

    done
else
    echo "Invalid credentials. Try again"
fi