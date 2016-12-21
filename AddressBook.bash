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
        echo =========
        echo "${results[@]}"
        echo --------
    fi

  done < ./Contacts

  echo search end
}

edit(){
	X=1
}
remove(){
	X=1
}

add_entries
search
