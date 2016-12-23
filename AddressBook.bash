#!/bin/bash

echo Welcome to Adress Book
echo it allows you to
echo      - Search address book
echo      - Add entries
echo      - Remove / edit entries
echo
echo

add_entries(){
	echo -n 'please enter the name\(s): '
	read name
#if name exists call edit
	echo -n 'Please enter $name phone number: '
	read phone_number
	echo -n 'Please enter $name email: '
	read email
	echo
	echo
	echo 'Name  :' $name
	echo 'Phone :' $phone_number
	echo 'Email :' $email
	echo
	echo -n 'Save the above contact \(Y/N): '
	read confirmation
    echo $confirmation
    echo
	if [ "$confirmation" = "Y" ]
		then
		touch Contacts
	
                echo "$name:$phone_number:$email" >> Contacts
		echo Done
		#save
fi
}

search (){
# This program is supposed to search for an entry in the database
# and list all valid results. it should then enable the user to
# choose one result


# Input the name to search (This part will be removed in future)
  echo -n "name to search: "
  read name
# Start the search
  echo search start
# Creating a variable to count the number of results and another
# to store the results
  count=0
  results=()

# The following loop reads each line of the file Contacts and stores
# the results in an array called results
  while read -r line 
  do
    echo "Processing $line"
    if [[ $line =~ $name ]] ; then
        echo "1 $name 2 $line" 
        count=$(( $count + 1 ))
        echo %%%%%%%%
        echo count $count line $line
        echo %%%%%%% 
        results+=($line)
        echo ========
        echo "${results[@]}"
        echo --------
    fi

  done < ./Contacts

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
# If only ine result is found, display it
  elif [ $count -eq 1 ] ; then
     echo ${results[picked]}
# If no result inform the user
  else
     echo $name does not exist in the database
  fi

  echo search end
}

edit(){
# This function takes input from the user to use to change existing
# contacts
#search $1
echo start edit
old='james:45727:jhd@ddy'
new='mary:5678:m90@wg'
sed -i "s/$old/$new/" ./Contacts
echo end edit
	
}

delete(){
# This function should enable you to delete a contact
#
echo start delete
entry='kevin:56:g@G'
sed -i "/$entry/d" ./Contacts 
echo end delete
}

#add_entries
#search
#edit
delete
