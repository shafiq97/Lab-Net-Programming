#!/bin/bash

edit_profile()
{
	echo "1. Change Username"
	echo "2. Update Phone Number"	
	echo "3. Update Email"	
	echo "4. Update Bank Name"
	echo "5. Update Bank Account Number"	
	read -p "Choose your choice with the number given: " choice
	

	if [ $choice -eq 1 ]; then
		read -p "Enter current username to continue ... : " u_name
		
		
			if grep -w $u_name "$fileuserpass"; then 
			
				var="$(grep -w $u_name "$fileuserpass")"
				read -p "Enter new username " name
				name="Username: $name"
				sed -i -e "s/$var/$name/g" $fileuserpass
		
			

			fi
	
	elif [ $choice -eq 2 ]; then
		read -p "Enter current phone number to continue ... : " phone
			
		
			if grep -w $phone "$filepath"; then 
			
				var="$(grep -w $phone "$filepath")"
				read -p "Enter new phone number" newphone
				newphone="Phone Number        :  $newphone"
				sed -i -e "s/$var/$newphone/g" $filepath
		
			

			fi
	fi

	


}

print_user_pdf()
{
	
	read -p "Enter your IC Number: " ic
	
	if grep -qw "$ic" "$filepath"; then 
	
		grep -B 1 -A 8  "$ic" "$filepath" > "$ic".txt
		
		enscript "$ic".txt -o - | ps2pdf - "$ic".pdf
		xdg-open "$ic".pdf   
		
	else
		echo "Username not found"
	fi
}

search_user()
{
	echo "1.Search user by name"
	echo "2.Search user by IC Number"
	read -p "Enter your choice using number given: " choice
	check_digits "$choice"
	echo ""
	

	if [ "$choice" = "1" ]; then
		read -p "Enter Name: " input

		if grep -qw "$input" "$filepath"; then 
			grep -B 0 -A 9  "$input" "$filepath"
		else
			echo "Name not found"
		fi

	elif [ "$choice" = "2" ]; then 

		read -p "Enter IC: " input

		if grep -qw $input "$filepath"; then 
			grep -B 1 -A 8  "$input" "$filepath"
		else
			echo "IC not found"
		fi
	fi
}

print_pdf()
{
	enscript "$filepath" -o - | ps2pdf - zakatfile.pdf
	xdg-open zakatfile.pdf   
}

new_admin_account()
{
	read -p "Enter new username: " username
	read -p "Enter new password: " password

	check_same "$username"

	if flag == true
		then

			echo "Username                : " $username >> "$fileadmin"
			echo "Password                : " $password >> "$fileadmin"
			echo "" >> "$fileadmin"
			echo "Account Created!"
	fi
}

check_same()
{
	input=$1
	if grep -qw $input $fileadmin $fileuserpass ;
 		then
     			echo "Number you entered exists... Back to main menu"
			echo ""
			flag=false
			sleep 3

			if grep -qw $input $fileuserpath;
				then
					main_menu_user
			
			elif grep -qw $input $fileadmin;
				then
					main_menu_admin
			fi
	fi
}

check_digits()
{
	input=$1	
	while ! [[ "$input" =~ ^[0-9]+$ ]]; do
		
		echo " Integers Only "
		input=""
		read -p " Enter again       : " input
	done
}

check_gender()
{
	
	input=$1
	last=${input: -1}
	check=$(( "$last" % 2 ))
	if [[ "$check" -eq 0 ]]; then
		myString="Female"
	else
		myString="Male"
	fi
	echo "Gender             :" $myString
}

write_gender()
{
	input=$1
	last=${input: -1}
	check=$(( "$last" % 2 ))
	if [[ "$check" -eq 0 ]]; then
		echo "Gender              :  Female " >> "$filepath"
	else
		echo "Gender              :  Male " >> "$filepath"
	fi
}

register_new()
{
	clear	
	read -p "Full Name          : " name
	read -p "New Username       : " username
	read -p "New Password       : " password
	read -p "Identity Card NO.  : " ic
	check_digits "$ic"
	check_same "$ic"
	check_gender "$ic" 
	cyear=$(date +"%Y")
	year="${ic:0:2}"
	year=$(( "$year" + 1900 ))
	cyear=$(( "$cyear" - "$year" ))
	echo "Age                : "$cyear
	read -p "Address            : " address
	read -p "Phone NO.          : " phone_num
	check_digits "$phone_num"
	read -p "Email              : " email
	

	while ! [[ $email = *"@"* ]]; do
		echo " Invalid email without '@' "
		read -p "Email              : " email
	done
	
	read -p "Bank Name          : " bank
	read -p "Bank Account NO.   : " bank_num
	check_digits "$bank_num" 
	
	now=$(date)
	time=$(date +"%T")

	echo "Name                : " $name >> "$filepath"
	echo "IC Number           : " $ic >> "$filepath"
	echo "Age                 : " $cyear >> "$filepath"
	write_gender "$ic"
	echo "Address             : " $address >> "$filepath"
	echo "Phone Number        : " $phone_num >> "$filepath"
	echo "email               : " $email >> "$filepath"
	echo "Bank Name           : " $bank >> "$filepath"
	echo "Bank Account Number : " $bank_num >> "$filepath"
	echo "Latest Date Edit    : " $now >> "$filepath"
	echo "" >> "$filepath"

	echo "Username : " $username >> "$fileuserpass"
	echo "Password : " $password >> "$fileuserpass"
	echo "" >> "$fileuserpass"
}

main_menu_user()
{
        clear 
	echo ""	
	echo "******** User Menu *************"
	echo "*                              *"
	echo "* 1. Zakat Calculator          *"
	echo "* 2. Print Profile Information *"
	echo "* 3. Edit Profile		     *"	
	echo "* 4. Exit   	             *"
	echo "********************************"
	read -p  "Please enter your choice in  the number given: " choice

	if [ $choice -eq 1 ]; then
		echo "ihihi"
	elif [ "$choice" -eq 2 ]; then 
		print_user_pdf
	elif [ "$choice" -eq 3 ]; then 
		edit_profile
	elif [ "$choice" -eq 4 ]; then 
		exit
	fi
}

main_menu_admin()
{
        clear 
	echo ""	
	echo "******** Admin Menu ********"
	echo "*                          *"
	echo "* 1. View User File        *"
	echo "* 2. New Admin Account     *" 
	echo "* 3. Search User   *"
        echo "* 4. Print user file PDF   *"
	echo "* 5. Exit                  *"
	echo "****************************"
	read -p  "Please enter your choice in  the number given: " choice

	if [ $choice -eq 1 ]; then
		clear
		echo "User Information"
		echo ""
		cat "/root/Desktop/zakatfile.txt"
	elif [ "$choice" -eq 2 ]; then 
		new_admin_account
	elif [ "$choice" -eq 3 ]; then 
		search_user
	elif [ "$choice" -eq 4 ]; then 
		print_pdf
	elif [ "$choice" -eq 5]; then 
		exit
		
	fi
}

loginn()
{
	echo "Login"
	read -p "Enter Username: " username
	read -p "Enter Password: " password
	
	if [ "$username" = "$password" ]; then
		echo "Username cannot be password"
		echo ""
		loginn
	fi 
	

	if grep -qw $username $fileuserpass; then
		if grep -qw $password $fileuserpass; then
			main_menu_user
		fi
	elif grep -qw $username $fileadmin; then
		if grep -qw $password $fileadmin; then
			main_menu_admin
		fi
	else
		echo "Login Error no record found"
		
	fi
}

filepath="/root/Desktop/zakatfile.txt"
fileuserpass="/root/Desktop/userpass"
fileadmin="/root/Desktop/admin"
flag=true

read -p "Do yo have an account? [Y/N]" choice

if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
	loginn
elif [ "$choice" = "n" ] || [ "$choice" = "N" ]; then 
	echo "*New admin account can only be made by another existing admin " 
	sleep 4
	register_new
fi

	

	
	
	
	










	        







