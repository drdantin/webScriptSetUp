#!/bin/bash
#This Script downloads from the internet tomcat server, MySql, and mysql 
#connector

#function asks User if want to begin Script pertaining to the web configuration(tomcat,mysql,mysql
#connector)
function askToExecute_Script(){

    printf "Hello would you like to execute configuration Script for Dochaven(Y/N?)\n"
    	read answer
    if [ $answer != "Y" ] ; then echo "Have a good day"
    	exit 
    	fi
			}
 
#Function to Notify User to be in Bash Shell?
#in book -if statement on pg 88-89 and 117-118
function isBash(){
    if [ $SHELL != "/bin/bash" ];then echo "Change shell to bash shell"
    exit 0 
    fi
               }

#Function to Install Homebrew if homebrew not installed.
function getBrew(){
     printf "Do you have Homebrew( Y/N)?\n"
     read answer
     if [ $answer != "Y" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
     fi

     haveBrew="$(brew ls --versions)"    
     if [ $haveBrew = ""]; then
        echo "Homebrew installation failed"
        exit 0
        fi
    brew update
    brew prune
    brew doctor
                }

#Install tomcat and store where it was installed in varaible tomcat.
function getTomcat(){

      haveWget="$(ls /usr/local/Cellar)"
      if [[ $haveWget != *"wget"* ]]; then
      	brew install wget
	fi     
      	wget http://mirrors.ibiblio.org/apache/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz
        tar xvzf apache-tomcat-8.5.5.tar.gz
                  }

#Function installs mysql connector and store where it was installed in variable mysql_connector.
function getSqlConnect(){

      wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz
      tar xvzf mysql-connector-java-5.1.39.tar.gz
                        }

function cleanForInstall(){

        sudo rm /usr/local/mysql
        sudo rm -rf /usr/local/mysql*
        sudo rm -rf /Library/StartupItems/MySQLCOM
        sudo rm -rf /Library/PreferencePanes/My*
        rm -rf ~/Library/PreferencePanes/My*
        sudo rm -rf /Library/Receipts/mysql*
        sudo rm -rf /Library/Receipts/MySQL*
        sudo rm -rf /private/var/db/receipts/*mysql*
        rm mysql*

        say Attention, read informational note from monitor
        printf "\n"
        printf "Turn on cpu volume\n"
        printf "After you press in Y, I will bring up ones Activity monitor. Press CPU column to\n"
        printf "get processes. Next, on the top right of the screen type in mysql.\n"
        printf "If there is a mysqld which is present, highlight the mysqld row and quit the process.\n"
        printf "In addition, for some reason the mysqld process, at times, goes off and on. One needs to put\n"
        printf "in the mysql installation password while mysyld process is active. Activity Monitor shows this\n"
        read answer

        if [ $answer == "Y" ]; then
           say Good
           open /Applications/Utilities/Activity\ Monitor.app/
        fi

        printf "\n"
        printf "When finished press Y\n"
        read answer

        if [ $answer == "Y" ]; then
            say Lets start with the Mysql installation.
                        fi
        }

#Function installs MySql and store where it was installed in variable mysql.
function getMySql(){
     
	say Note, that if you enter in the mysql password incorrectly, you must go through the process again.

        printf "\n"
        printf "Write down initial password for root@localhost when it shows through installation process.\n"
        printf "\n"
        wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.16-osx10.11-x86_64.dmg
        open mysql-5.7.16-osx10.11-x86_64.dmg

        printf "\n"
        echo "Record password from mysql installation."
        printf "\n"

        #Ask User if the installation process is complete
        printf "\n"
        echo "If installation is complete type in Y, and if the installation was not able to be finished press N."
        read answer
        printf "\n"

        if [ $answer != "Y" ]; then
          printf "A problem occurred. Try again later.\n"
          exit
          fi


        #As Mysql is installed, go to /usr/local/mysql/bin. When in directory bin implement
        #command ->   ./mysql -u root -p

        printf "\n"
        printf "The Enter Password prompt is coming up.It is prompting for the mysql installation password\n"
        printf "\n"
        printf "Once the User is in mysql prompt, one will enter Use mysql or anything could do.\n"
        printf "\n"
        printf "A prompt is shown to use ALTER USER, instead enter: SET PASSWORD = PASSWORD('yourpassword')\n"
        printf "\n"
        printf "If the password does not go through the Enter Password prompt try running program again.\n"
        printf "\n"
        printf "Sometimes the letters are not clear as to what they are, for example I and l look the same.\n"
	printf "\n"
        printf "Lastly, after successful resetting of password type exit. In exiting mysql thread\n"
        printf "Press Y to continue.\n"
        read answer

        if [ $answer != "Y" ]; then
                printf " You are exiting. "
                exit
                fi


        cd /usr/local/mysql/bin
        ./mysql -u root -p
        printf "\n"

        printf "If there was an ERROR, press Y.\n"
        read answer
        if [ $answer == "Y" ]; then
                exit
                fi

        say Now I will fill up beginning information for Database Dochaven

       #Create database
       say Put in your My Sequel password
       ./mysql -u root -p -e "create database filehaven";

       ./mysql -u root -p -e "CREATE TABLE filehaven.User (id INT(6), name VARCHAR(20), email VARCHAR(20), isAdmin BOOL)";
       ./mysql -u root -p -e "INSERT INTO filehaven.User VALUES('200001','John Ham','jh@gmail.com', FALSE)";
       ./mysql -u root -p -e "INSERT INTO filehaven.User VALUES('100001','Johnny Utah','ju@gmail.com',TRUE)";
       printf "\n"
       printf "WebConfig bash Script has completed\n"

       say Script Completed
       exit
	}

function showLocation(){

        printf "/n"
	printf "Mysql Server dmg is in directory where you ran webconfigScript\n"
	printf "Mysql executables are in /usr/local/mysql/bin\n"
	printf "Mysql Connector and Tomcat are in the directory one ran script in\n"

	say Peace out and keep it real

}
		askToExecute_Script
		isBash
		getBrew
		getTomcat
		getMySql
		cleanForInstall
		getSqlConnect
                showLocation

		exit 0
