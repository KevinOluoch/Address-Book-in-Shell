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

	X=2
}
edit(){
	X=1
}
remove(){
	X=1
}

add_entries
