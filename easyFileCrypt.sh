#!/bin/bash

#Small bit of config here
#EDITOR=nano

##
#
# v1
#
# This is a simple text and file encryption program.
# You can encrypt and decrypt [1] text files (made within this program)...
# [2] files, and [3] compress and encrypt archives (folders).
#
# This program has absolutely no warranty... things may break, so just follow along with instructions (I have made some failsafes just incase).
#
# This program uses aes-256-ecb's encryption algorithm via the openssl command.
#
# Yours, BobyMCbobs of https://github.com/BobyMCbobs
#
#        ________
#        < Enjoy! >
#        --------
#               \   ^__^
#                \  (oo)\_______
#                   (__)\       )\/\
#                      ||----w |
#                      ||     ||
#
##

menu() {

if [ -f edit-encFun.sh ]
then
	rm edit-encFun.sh
fi

checkEditor=$(head -n 4 easyFileCrypt.sh | grep EDITOR= | cut -f2 -d '=')
progVer=$(head -n 8 easyFileCrypt.sh | tail -n 1 | awk {'print $2'})

OPTION=$(whiptail --title "Welcome to easyFileCrypt." --menu "Please choose your option" --backtitle "using $checkEditor as text editor | easyFileCrypt $progVer" 15 60 8 \
"1" "Encrypt" \
"2" "Decrypt" \
"3" "Settings" \
"4" "Exit"  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]
then
	if [ $OPTION = 1 ]
	then
		encryptMain

	elif [ $OPTION = 2 ]
	then
		decryptMain

	elif [ $OPTION = 3 ]
	then
		configMain

	elif [ $OPTION = 5 ]
	then
		exit
	fi

else
	exit
fi

}

function encryptMain() {
#Encryption Menu

OPTION=$(whiptail --title "Encrypt menu." --menu "Please choose your option" 15 60 8 \
"1" "Make text file" \
"2" "Use existing text file" \
"3" "Use normal file" \
"4" "Use a folder" \
"5" "Back"  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]
then
	if [ $OPTION = 1 ]
	then
		makeTextFile

	elif [ $OPTION = 2 ]
	then
		encryptTextFile

	elif [ $OPTION = 3 ]
	then
		encryptFile

	elif [ $OPTION = 4 ]
	then
		encryptTar

	elif [ $OPTION = 5 ]
	then
		menu
	fi
else
	exit
fi


}


function makeTextFile() {
#Write message and encrypt

if [ $checkEditor = "nano" ]
then
	nano .encmsg.txt

elif [ $checkEditor = "vi" ]
then
	vi .encmsg.txt

fi

ckempt=$(du -h .encmsg.txt | cut -b 1)

nameFile

passCompare

cat .encmsg.txt | openssl aes-256-cbc -a -salt -out $fileName -pass pass:$passPhrase
rm .encmsg.txt

menu

}

function nameFile() {
#Names the file that it will save it as

fileName=$(whiptail --inputbox "Give your file a full name:" 8 78 --title "File Name" --nocancel 3>&1 1>&2 2>&3)

}


function encryptTextFile() {
#Encrypt already existing text file
findTheFile=$(whiptail --inputbox "What's your text file's name?" 8 78 --title "File Name" --nocancel 3>&1 1>&2 2>&3)

if [ -f $findTheFile ]
then
        whiptail --title "Found file: '$findTheFile'" --msgbox "OK to continue" 8 78

	nameFile
	passCompare

	cat $findTheFile | openssl aes-256-cbc -a -salt -out $fileName -pass pass:$passPhrase

	whiptail --title "'$fileName' saved." --msgbox "Press OK" 8 78

else
        whiptail --title "Could not find file: '$findTheFile'" --msgbox "Press OK to try again" 8 78

fi

}


function encryptFile() {
#Encrypt regular file
findTheFile=$(whiptail --inputbox "What's your file's name?" 8 78 --title "File Name" --nocancel 3>&1 1>&2 2>&3)

if [ -f $findTheFile ]
then
        whiptail --title "Found file: '$findTheFile'" --msgbox "OK to continue" 8 78

        nameFile
        passCompare

        openssl aes-256-cbc -a -salt -in $findTheFile -out $fileName -pass pass:$passPhrase

        whiptail --title "'$fileName' saved." --msgbox "Press OK" 8 78

else
        whiptail --title "Could not find file: '$findTheFile'" --msgbox "Press OK to try again" 8 78

fi

}


function encryptTar() {
#Make archive of folder and encrypt
findTheFile=$(whiptail --inputbox "What's your folder's name?" 8 78 --title "Folder name" --nocancel 3>&1 1>&2 2>&3)

if [ -d $findTheFile ]
then
        nameFile
        tar -cvf .tmparch.tar $findTheFile

	if [ -f .tmparch.tar ]
	then

        	whiptail --title "Compression complete" --msgbox "Press OK" 8 78
        	passCompare
	        openssl aes-256-cbc -a -salt -in .tmparch.tar -out $fileName -pass pass:$passPhrase

		if [ -f $fileName ]
		then

	        	rm .tmparch.tar
		        whiptail --title "Encryption complete" --msgbox "Press OK" 8 78

		fi
	fi

else
	whiptail --title "'$findTheFile' not found" --msgbox "Press OK" 8 78
	encryptTar

fi


}


function decryptMain() {
#Decryption Menu

OPTION=$(whiptail --title "Decrypt menu." --menu "Please choose your option" 15 60 8 \
"1" "Use text file" \
"2" "    \-- Modify" \
"3" "Use normal file" \
"4" "Use a tar/archive" \
"5" "Back"  3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]
then
	if [ $OPTION = 1 ]
	then
		decryptText

	elif [ $OPTION = 2 ]
	then
		modifyMain

	elif [ $OPTION = 3 ]
	then
		decryptFile

	elif [ $OPTION = 4 ]
	then
		decryptTar

        elif [ $OPTION = 5 ]
        then
                menu
        fi
else
        exit
fi


}

function decryptText() {
#decrypt text file

findName=$(whiptail --inputbox "You can use full directories, use extentions" 8 78 --title "What is the file name?" --nocancel 3>&1 1>&2 2>&3)
exitstatus=$?

if [ -f $findName ]
then

	if [ $exitstatus = 0 ]; then

		passPhrase=$(whiptail --passwordbox "Found '$findName'; Please enter the decryption key:" 8 78  --title "Decryption key" --nocancel 3>&1 1>&2 2>&3)
		exitstatus=$?

		if [ $exitstatus = 0 ]; then

#			fileName=$(whiptail --inputbox "What would you like to call it?" 8 78 --title "File Name" 3>&1 1>&2 2>&3)
			cat $findName | openssl aes-256-cbc -a -d -salt -out .tempDec -pass pass:$passPhrase

			if [ -f .tempDec ]
			then
				isTempDecEmpty=$(du -h .tempDec | cut -b 1)
				if [ $isTempDecEmpty = "0" ]
				then
					whiptail --title "Error" --msgbox "Decryption failed." 8 78
					menu
				fi
			fi

	               	if (whiptail --title "Save" --yesno "Would you like to save?" 8 78)
			then
				fileName=$(whiptail --inputbox "What would you like to call it?" 8 78 --title "File Name" --nocancel 3>&1 1>&2 2>&3)
				cat .tempDec > $fileName
				viewDecryptedText
				rm .tempDec
				menu
			else

				viewDecryptedText
				rm .tempDec
				menu
			fi
		else
        		echo
		fi

	#

	else
        	echo
	fi


else
	whiptail --title "Could not find file" --msgbox "Press OK to try again" 8 78
	decryptText

fi

}

function decryptFile() {
#decrypt a single file
findTheFile=$(whiptail --inputbox "What's your file's name?" 8 78 --title "File Name" --nocancel 3>&1 1>&2 2>&3)

if [ -f $findTheFile ]
then
        whiptail --title "Found file: '$findTheFile'" --msgbox "OK to continue" 8 78

        nameFile
        passPhrase=$(whiptail --passwordbox "Found '$findName'; Please enter the decryption key:" 8 78  --title "Decryption key" --nocancel 3>&1 1>&2 2>&3)

        openssl aes-256-cbc -a -d -salt -in $findTheFile -out $fileName -pass pass:$passPhrase

        whiptail --title "'$fileName' has been decrypted" --msgbox "Press OK" 8 78

else
        whiptail --title "Could not find file: '$findTheFile'" --msgbox "Press OK to try again" 8 78
	decryptFile
fi

}

function decryptTar() {
#Decrypt an encrypted archive
findTheFile=$(whiptail --inputbox "What's your encrypted archive's name?" 8 78 --title "archive name" --nocancel 3>&1 1>&2 2>&3)

if [ -f $findTheFile ]
then

	passPhrase=$(whiptail --passwordbox "Found '$findTheFile'; Please enter the decryption key:" 8 78  --title "Decryption key" --nocancel 3>&1 1>&2 2>&3)
	openssl aes-256-cbc -d -a -salt -in $findTheFile -out .tmparch.tar -pass pass:$passPhrase

        if [ -f .tmparch.tar ]
        then

		tar -xvf .tmparch.tar > /dev/null

                whiptail --title "Extraction complete" --msgbox "Press OK" 8 78

                if [ -f $fileName ]
                then

                        rm .tmparch.tar

                fi
        fi

else
        whiptail --title "'$findTheFile' not found" --msgbox "Press OK" 8 78
        decryptTar

fi

}

function viewDecryptedText() {
#View the text that was just decrypted

if (whiptail --title "View your text?" --yesno "View your decrypted message." 8 78)
then
   	#Yes
	whiptail --textbox .tempDec --scrolltext 20 78
fi

}

function modifyMain() {
#Modify text file menu
findTheFile=$(whiptail --inputbox "What's your text file's name?" 8 78 --title "Text file name" 3>&1 1>&2 2>&3)

if [ -f $findTheFile ]
then

	whiptail --title "'$findTheFile' found" --msgbox "Press OK" 8 78

	passPhrase=$(whiptail --passwordbox "Please enter the encryption key:" 8 78  --title "Encryption key" --nocancel 3>&1 1>&2 2>&3)

	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		echo
	else
		modifyMain
	fi

        openssl aes-256-cbc -a -d -salt -in $findTheFile -out .modmsg.txt -pass pass:$passPhrase
        cat .modmsg.txt > .modmsgt.txt
        #nano .modmsg.txt

	if [ $checkEditor = "nano" ]
	then
        	nano .modmsg.txt

	elif [ $checkEditor = "vi" ]
        then
		vi .modmsg.txt

	fi

        changes1=`cksum .modmsg.txt | awk -F" " '{print $1}'`
        changes2=`cksum .modmsgt.txt | awk -F" " '{print $1}' `

                if [ $changes1 = $changes2 ]
                then
			whiptail --title "No changes" --msgbox "Press OK to return" 8 78
                        rm .modmsg*.txt

                else

			whiptail --title "'$findTheFile' modified" --msgbox "Press OK to save" 8 78
                	openssl aes-256-cbc -a -salt -in .modmsg.txt -out .modmsg2.txt -pass pass:$passPhrase

                        cat .modmsg2.txt > $findTheFile
                        rm .modmsg*.txt

                fi

else
	whiptail --title "'$findTheFile' not found" --msgbox "Press OK to return" 8 78

fi

}


function configMain() {
#Tune up encFun.sh to how you like it
checkEditor=$(head -n 4 easyFileCrypt.sh | grep EDITOR= | cut -f2 -d '=')

if (whiptail --title "Example Dialog" --yesno "This is an example of a yes/no box." --yes-button "Nano" --no-button "Vi" 8 78)
then

	if [ $checkEditor = "vi" ]
	then
		echo "sed -i -e '4s/#EDITOR=vi/#EDITOR=nano/g' easyFileCrypt.sh" >> edit-eFC.sh
		echo 'whiptail --title "Nano set" --msgbox "Press OK to continue" 8 78' >> edit-eFC.sh
		bash edit-eFC.sh
		rm edit-eFC.sh
		menu
	else
		menu

	fi
else

	if [ $checkEditor = "nano" ]
	then
		echo "sed -i -e '4s/#EDITOR=nano/#EDITOR=vi/g' easyFileCrypt.sh" >> edit-eFC.sh
		echo 'whiptail --title "Vi set" --msgbox "Press OK to continue" 8 78' >>  edit-eFC.sh
       	 	bash edit-eFC.sh
		rm edit-eFC.sh
		menu
	else
		menu

	fi
fi

}

function helpMenu() {
#print help guide
helpText="Welcome to encFun!

1. Encrypting data
	-
	-
	-

2. Decrypting data
	-
	-
	-

3. Modifying data
	-
	-
	-

"
whiptail --textbox /dev/stdin 40 80 --scrolltext <<< "$helpText"

menu

}

function passCompare {
#compare passwords to encrypt files and users type; declear passPhrase variable

#1st
passPhrase=$(whiptail --passwordbox "Please enter the encryption key:" 8 78  --title "Encryption key" 3>&1 1>&2 2>&3)

#exitstatus=$?
#if [ $exitstatus = 0 ]; then
#        echo
#else
#        echo
#fi

#2nd
passPhrase2=$(whiptail --passwordbox "Please repeat the encryption key:" 8 78  --title "Encryption key" 3>&1 1>&2 2>&3)

#exitstatus=$?
#if [ $exitstatus = 0 ]; then
#        echo
#else
#        echo
#fi


if [ "$passPhrase" = "$passPhrase2" ]
then
        whiptail --title "Passphrases match... continuing" --msgbox "Press OK to continue" 8 78
	#whiptail --textbox itWorkedBoxPF 8 78
else
        whiptail --title "Passphrases do not match, please try again." --msgbox "Press OK to redo" 8 78
	passCompare
fi

}

menu
