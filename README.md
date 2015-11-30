# NewSSHLogon
Set up easy logon for SSH interactions

Usage: newLogon.sh [OPTION]... [servername abbreviation userid]
Configure a new ssh logon for easy use.
 
  The severname, abbreviation, and userid information can
  be entered on the command line or as positional 
  parameters following the options. 
  
  * If entered as positional parameters, all three are required. 
  * If some or none are entered as options, then the user will prompted for any of the three that are missing.  
  * In order to avoid prompts enter all three using either method, plus the '-p password' option. 
  
  ## Options
  
   * -s servername      name of server to be connnected to 
   * -a abbreviation    mnemonic for the server
   * -u userid          userid on the server
  
   * -v                 verbose output
   * -d                 dry run, no real config of ssh
   * -h                 display this help information and exit
   * -p password        password on configured server 

