#!/bin/bash

echo Welcome to Address Book
echo it allows you to
echo      - Search the Contact book
echo      - Add entries
echo      - Remove / edit entries
echo
echo

add_entries(){
# This function can add an entry into the contacts list and
# ensures that all entries are unique


     # Prompt the user to enter a name, it must start with
     # an letter and contain only letters and numbers
     while true
        do
	echo -n 'please enter the name(s): '
	read name
        
        # Check if name is valid then check if it already exists
        if [[ $name =~ ^[[:alpha:]][[:alnum:]]+$ ]] # Checking if name is valid
          then
          echo 
          echo \n Confirming  $name is not in database
          search $name 1 #search for the name in database
          status=$? 
          # If name is not in database procede
          if [ $status -eq 0 ] ;then
            echo $name is NOT in database 
            break
          fi
          # If name is in database  the user should edit existing 
          # contact name or enter another name
          if [ $status -eq 1 ] ;then
            echo The name $name, exists in the database
            while true
              do
              echo -n "Edit existing $name's name to create room for the new contact? (Y,N): "
              read confirmation
              if [[ $confirmation =~  ^[Nn]$ ]]; then
                 break
              fi
              if [[ $confirmation =~  ^[Yy]$ ]]; then
                edit $name 
                break
              fi
            done
            # If confirmation was yes the existing contact was edited
            # you can now procede with creating the contact with the 'name'
            if [[ $confirmation =~  ^[Yy]$ ]]; then
                break
            fi

          fi

        fi
      done

     # Prompt user to enter a valid phone number
      while true
        do
        echo
	echo -n "Please enter $name phone number: "
	read phone_number
        if [[ $phone_number =~ ^[[:digit:]]+$ ]]
          then
          echo number ok
          break
        fi
      done

     # Prompt user to enter a valid email
      while true
        do
        echo
	echo -n "Please enter $name email: "
	read email
        if [[ $email =~ ^[[:alpha:]][[:alnum:]]+@[[:alpha:]]+.com$ ]]
          then
          echo email ok
          break
        fi
        done
      # The user should confirm, they want to save the contact
	echo
	echo
	echo 'Name  :' $name
	echo 'Phone :' $phone_number
	echo 'Email :' $email
	echo
      # Ensure the confirmation is valid
      while true
        do
	echo -n 'Save the above contact (Y/N): '
	read confirmation
        if [[ $confirmation =~  ^[YNyn]$ ]]; then
           break
        fi
      done
    echo $confirmation
    echo
    # If confirmation is Yes save the contact
    if [[ "$confirmation" =~ ^[Yy]$ ]]
      then
      touch Contacts
      echo "$name:$phone_number:$email" >> Contacts
      echo Saved 
    # else dicard the contact
    else
      echo The Contact was discarded
    fi
}

search (){
# This program is supposed to search for an entry in the database
# and list all valid results. it should then enable the user to
# choose one result

# The name to be searched if the first argument called with the function
  echo
  echo Searching for $1 in contacts 
  local  name=$1

# Creating a variable to count the number of results and another
# to store the results
  count=0
  results=()

# The following loop reads each line of the file Contacts and stores
# the results in an array called results
  while read -r line 
  do
 #  echo "Processing $line"
    search_expr="^$name:[[:digit:]]+:[[:alpha:]][[:alnum:]]+@[[:alpha:]]+.com$" 
    if [[ $line =~ $search_expr ]] ; then
    #   echo "1 $name 2 $line" 
        count=$(( $count + 1 ))
    #   echo %%%%%%%%
    #   echo count $count line $line
    #   echo %%%%%%% 
        results+=($line)
    #   echo ========
    #   echo "${results[@]}"
    #   echo --------
    fi

  done < ./Contacts

# If the search request came from add entries, return the results
  if [ $2 -eq 1 ] ; then
      if [ $count -eq 0 ] ; then
          return 0
      else
          return 1
      fi
  fi

# The user is then given an option of selecting one result
  index=0
# Enabling selection if more than one result is found
  if [ $count -gt 1 ] ; then
     echo which $name?
     # Displaying all the results
     for result in ${results[@]}
        do
        index=$(( $index + 1 ))
        echo $index: $result
     done
     selected=0
     # Reading the users selected result
     while true
         do
         echo Please enter the corresponding number
         read picked
         if [[ $picked =~ ^0+?[1-9]+$ ]] ; then
             if (( $picked >= 1 && $picked <= $count )) ; then
                 break
             fi
         fi
     done
     # Displaying the result
     echo 
     echo $picked picked
     echo name:  ${results[$(( $picked - 1 ))]%:*:*}
     XX=${results[$(( $picked - 1 ))]#*:} 
     echo Phone Number:  ${XX%:*} 
     echo Email:  ${results[$(( $picked - 1 ))]#*:*:} 
     echo 
     rst=${results[$(( $picked - 1 ))]}
     return 2
# If only one result is found, display it
  elif [ $count -eq 1 ] ; then
     echo
     echo name:  ${results[0]%:*:*}
     XX=${results[0]#*:} 
     echo Phone Number:  ${XX%:*} 
     echo Email:  ${results[0]#*:*:} 
     echo 
      rst=${results[0]}
     return 2
    
# If no result inform the user
  else
     echo The name $name does not exist in Contacts
     rst=$results
     return 3
  fi

  echo search end
}

edit(){
# This function takes input from the user to use to change existing
# contacts

search $1 1
if [ $? -eq 1 ] ; then
    # Seeking confirmation before deleting
    while true
        do
        search $1 2
        echo -n 'EDIT the above contact (Y/N): '
        read confirmation
        if [[ $confirmation =~  ^[YNyn]$ ]]; then
            break
        fi
    done
    if [[ $confirmation =~ [Yy] ]] ; then
        while true
            do
            echo -n "Please enter the new name to replace $1: "
            read new_name
            search $new_name 1
            if [ $? -eq 0 ] ; then
               echo $new_name is not in Contacts
               break
            fi
            echo $new_name exists in the database
        done
        echo
        echo editing .....
        search $1 2
        search_return=$?
        echo 
        echo replacing $1 with $new_name .....
        echo
        rst2=${rst/$1/$new_name}
        sed -i "s/$rst/$rst2/" ./Contacts
        echo editing complete
    else
        echo No Editing done
        echo
    fi
else
    echo $1 does not exist in contacts
fi
 
}

delete(){
# This function should enable you to delete a contact
#
echo start delete
#entry='kevin:56:g@G'
search $1 2
search_return=$?
#echo search_return $search_return
if [ $search_return == "3" ] ; then
    echo 
    echo $1 does not exist in contacts 
    echo 
else
    # Seeking confirmation before deleting
    echo 
    while true
        do
	echo -n 'DELETE the above contact (Y/N): '
	read confirmation
        if [[ $confirmation =~  ^[YNyn]$ ]]; then
           break
        fi
      done

   if [[ $confirmation =~ [Yy] ]] ; then
       # Remove the contact
       sed -i "/$rst/d" ./Contacts
       # Remove the empty line remaining
       sed -i "/^ *$/d" ./Contacts
       echo $1 has been deleted
       echo 
   else
       echo $1 has NOT been deleted
   fi
fi
 
echo end delete
}

main(){
#This function 

while true
    do
    echo -n 'Prompt >> '
    read action

    # Call add_entries function if add is typed
    if [[ $action =~ ^add$ ]] ; then
        add_entries 

    # Call search function if search <name> is typed
    elif [[ $action =~ ^search[[:space:]]+[[:alnum:]]*$ ]] ; then
        input_name=${action/search/}  # Retrieve the name 
        search $input_name 2

    # Call edit fuction if edit <name> is typed
    elif [[ $action =~ ^edit[[:space:]]+[[:alpha:]][[:alnum:]]*$ ]] ; then
        input_name=${action/edit/}  # Retrieve the name 
        edit $input_name 

    # Call delete function if delete <name> is typed
    elif [[ $action =~ ^delete[[:space:]]+[[:alpha:]][[:alnum:]]*$ ]] ; then
        input_name=${action/delete/}  # Retrieve the name 
        delete $input_name 

    # Provide help information if help <command> is typed
    elif [[ $action =~ ^help[[:space:]]+[[:alnum:]]*$ ]] ; then
        input_command=${action/\help/} # Retrieve command
        if [ $input_command == "add" ] ; then
            echo usage: add
            echo This command is used to add entries to contact list
            echo
        elif [ $input_command == "search" ] ; then
            echo 'usage: search <name>'
            echo This command is used to search the given name
            echo
        elif [ $input_command == "edit" ] ; then
            echo 'Usage: edit <name>'
            echo Used to edit existing Contact names
            echo
        elif [ $input_command == "delete" ] ; then
            echo 'Usage: delete <name>'
            echo used to delete Contact entries
            echo
        elif [ $input_command == "q" ] ; then
            echo 'Usage : q '
            echo Exits the progam
            echo
        else 
            echo $input_command is not a valid command
            echo
        fi

    # Exits the program when q is typed
    elif [[ $action =~ ^q$ ]] ; then
        echo else option
        echo $action
        break

    # If the input is not a valid command
    # display the following information
    else
        echo
        echo Please enter one of the following commands:
        echo "    add "
        echo "    search <name>"
        echo "    edit <name>"
        echo "    delete <name>"
        echo "    help <command>"
        echo 
    fi
done

}

#add_entries
#search
#edit
#delete job 2
main


