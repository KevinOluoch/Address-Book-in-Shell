#!/bin/bash

#TODO 
# Add an appropirate license"

echo "Welcome to the AddressBook bash app!"
echo "AddressBook allows you to: "
echo "     - Search for address in the database"
echo "     - Add new contacts"
echo "     - Edit and remove existing contacts"
echo "                               "
echo "                               "

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
            edit $name 1
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
    echo Saved Done
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
    echo $picked picked
    echo ${results[$(( $picked - 1 ))]}
    return ${results[$(( $picked - 1 ))]}
    # If only ine result is found, display it
  elif [ $count -eq 1 ] ; then
    echo ${results[picked]}
    return ${results[picked]}
    # If no result inform the user
  else
    echo $name does not exist in the database
    return 0
  fi

  echo search end
}

edit(){
  # This function takes input from the user to use to change existing
  # contacts

  echo start edit
  search $1 1
  returned_entry=$?
  # WHAT IF REPLACEMENT NAME EXISTS
  if [[ $2 -eq 1 ]] ; then
    old_name=$1
    # Get new entry from the user
    while true
    do
      echo -n "Please enter the new name to replace $1: "
      read new_name
      search $new_name 1
      if [ $? -eq 0 ] ; then
        echo replacing $old_name with $new_name
        break
      fi
      echo $new_name exists in the database
    done
  fi
  echo
  echo editing .....
  sed -i "s/$old_name/$new_name/" ./Contacts
  echo editing complete
  echo end edit
  echo

}

delete(){
  # This function should enable you to delete a contact
  #
  echo start delete
  entry='kevin:56:g@G'
  sed -i "/$entry/d" ./Contacts 
  echo end delete
}

add_entries
#search
#edit
#delete
