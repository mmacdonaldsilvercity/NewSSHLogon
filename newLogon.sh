#  TODO: 
#      test for pre-existing sname abbrv uid parms
#        and if there, don't prompt
#      ssh-keygen to discreet function
#      complete dry run and verbose messages and logic
#      install message/error handling function
#        case based on message number, echos all in the 
#        one place for readability

# ------------------------------------------------------- #
function showHelp() {

#   showHelp function:  Invoked directly out of the getopts
#   logic.  There are no input or output variables. 

echo " "
echo "Usage: newLogon.sh [OPTION]... [servername abbreviation userid]"
echo "Configure a new ssh logon for easy use."
echo " "
echo "  The severname, abbreviation, and userid information can"
echo "  be entered as follows on the command line or as positional "
echo "  parameters following the options. "
echo "  "
echo "  * If entered as positional parameters, all three are required. "
echo "  * If some or none are entered as options, then the user will "
echo "    prompted for any of the three that are missing.  " 
echo "  * In order to avoid prompts enter all three using either " 
echo "    method, plus the '-p password' option. "
echo "  "
echo "   -s servername      name of server to be connnected to "
echo "   -a abbreviation    mnemonic for the server"
echo "   -u userid          userid on the server"
echo "  "
echo "   -v                 verbose output"
echo "   -d                 dry run, no real config of ssh"
echo "   -h                 display this help information and exit"
echo "   -p password        password on configured server "
echo " "
}

# ----------------------------------------------------------- #
function yesTest() {

#   yesTest function:  helper function for evaluating
#      boolean conditions
#
#   Input and Output is $goflag

	val='NO'
	
	case $goflag in
   	y) val='YES';;
   	yes) val='YES';;
   	Y) val='YES';;
   	YES) val='YES';;
	esac
	
   if [ $val = 'YES' ]
   then
      goflag='yes'
   else
   	goflag='no'
   fi
}

# ----------------------------------------------------------- #
function loadSSHConfig() {

#   loadSSHConfig function:  for readabiilty, separate load into
#      discreet function.
#   No function input variables or output variables
#   Function appends ~/.ssh/config with new logon parms

	if [ verbose='yes' ]
	then
		echo '  Backing up orig to ~/.ssh/config~'
	fi
	if [ testing='no' ]
	then
   	cp ~/.ssh/config ~/.ssh/config~
   else
   	echo "newLogon I001: Would have backed up config here"
   fi
   if [ verbose='yes' ]
   then
   	echo '  Appending on to config file the following:'
   	echo "Host $abbrv" >> ~/.ssh/configx
   	echo "    Hostname $sname" >> ~/.ssh/configx
   	echo "    User $uid" >> ~/.ssh/configx
   	echo "  Here is the complete ssh config for this user:"
   	less ~/.ssh/configx
   	echo " *** "
   fi
   echo " You will now be asked for your password on the "
   echo " newly configured ssh connection as ssh-copykey is run."
   read -p " OK to continue? y or n: " goflag
   
   yesTest
   
   if [ $goflag = 'yes' ]
   then
   	if [ testing='no' ]
   	then
      	ssh-copy-id $uid\@$sname
      else
      	echo "newLogon I002: Would have executed: ssh-copy-id $uid@$sname "
		fi
   fi
}

# ----------------------------------------------------------- #
#
#   Main processing logic 
#

testing='no'
verbose='no'
sname='blank'
abbrv='blank'
uid='blank'
helpme='no'

while getopts "hdvs:" arg
do
	  echo "got the argument: $arg"
	  
     case "${arg}" in
    
       d) testing='yes';;
       v) verbose='yes';;
       h) showHelp
       	 exit;;
       u) uid=$OPTARG;;
       s) sname=$OPTARG;;
       a) abbrv=$OPTARG;;
       *) echo "newLogon e002: getopts detected invalid argument"
          echo "   Use option -h for valid options"
          exit;;
     esac
done  
	
shift $(($OPTIND -1))

if [ $3 ] 
then 
	uid=$3
	abbrv=$2
	sname=$1
	if [ verbose='yes' ]
	then
		echo "user id: $uid"
		echo " abbrev: $abbrv"
		echo " server: $sname"
	fi
elif [ $# = '0' ]
then
	if [ verbose='yes' ]
	then
		echo "newLogon I003: no positional parms entered"
	fi
else
	echo "newLogon e003: Invalid number of positional parms entered: $#"
	exit
fi

if [ -e ~/.ssh/id_rsa ]
then
	if [ verbose='yes' ]
	then
		echo "    You have run ssh-keygen, so you are set to go"
	fi
else
	echo "    You have not run ssh-keygen.  If you wish to do so"
	read -p "    now, enter 'Y': " goflag
	yesTest 

   if [ $goflag = 'YES' ]
   then
#   	ssh-keygen
      echo "Would have run keygen here"
   fi
fi  

#  TODO:  find correct format for empty/nonexistant variable
if [ -s sname ]
then	
	read -p "          Enter server name: " sname
fi	
read -p "         Enter abbreviation: " abbrv
read -p "Enter the remote server uid: " uid

echo "Following is the data to be added to ~/.ssh/config:"

echo "Host $abbrv" 
echo "    Hostname $sname"
echo "    User $uid"

read -p "--> OK? y or n: " goflag 

yesTest

if [ $goflag = 'yes' ]
then
	loadSSHConfig    
else
    echo "Process Aborted, no changes made"
fi


