add_file () {
    touch $1
    cd ..
}

while true; do 


    echo "Welcome to the Codebase Management System

    Which option would you like to use today?
    1: Make a new repository
    2: Check files into existing repository
    3: Check files out of existing repository
    0: Exit"

    read menuChoice

    if [ $menuChoice = 1 ]
    then 

        echo "Enter the name of the new repository you wish to create
        "

        read repName

        mkdir $repName 2>/dev/null || echo "A repository with this name already exists"

        if [ -d "$repName" ]
        then

            echo "Enter the name of the initial file for the repository"

            read fileName

            add_file "$fileName"

            while true; do

                echo "Do you wish to add another file? Y/N"

                read newFileChoice

                if [ ${newFileChoice^^} = 'Y' ]
                then
                    echo "Enter the name of the new file"

                    read fileName

                    add_file "$fileName"
                elif [ ${newFileChoice^^} == "N" ]
                then
                    break
                
                else
                echo "Invalid input, please try again

                "

                fi
            done

    elif [ $menuChoice = 0 ]
    then

        exit

    fi
done
