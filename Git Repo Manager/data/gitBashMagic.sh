PROJECT_DIR=$1
GIT_COMMAND=$2
REPO_LIST=$3
REQUIRE_LOGIN=$4
SOUND_ENABLED=${5:-0}

# Set Bash window title - https://stackoverflow.com/a/46459553
echo -e "\033]0;Git Repo Manager: Bash Instance\007"

# Variables for colors
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
NC=$(tput sgr0)

echo -e "${CYAN}\t*** Git Repository Manager ***"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
echo 
echo -e -n "\e[2;30;47m  > Working Project Directory \e[0m\n\t"
echo $PROJECT_DIR
echo
echo -e -n "\e[2;30;47m  > Running Git Command \e[0m\n\t"
echo $GIT_COMMAND
echo
echo -e "\e[2;30;47m  > Selected Repository List \e[0m"
for REPO in $REPO_LIST
do
	echo -e -n "\t"
    echo $REPO
done

if [ $REQUIRE_LOGIN -eq 1 ]
then
	[ $SOUND_ENABLED -eq 1 ] && powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\chord.wav').PlaySync()" &
	echo 
	echo --------------------------------------------------
	echo "${YELLOW}(!) SSH login required to execute command '$GIT_COMMAND'${NC}"
	echo "(*) Starting SSH agent..."
	eval $(ssh-agent)
	ssh-add
fi

for REPO in $REPO_LIST
do
	echo 
	echo --------------------------------------------------
    echo "${GREEN}>>> $REPO${NC}"
	echo --------------------------------------------------
	cd $PROJECT_DIR
	cd $REPO
	eval ${GIT_COMMAND}
done

[ $SOUND_ENABLED -eq 1 ] && powershell -c "(New-Object Media.SoundPlayer 'C:\Windows\Media\tada.wav').PlaySync()" &
echo 
echo ==================================================
echo "${YELLOW}(!) All done! ${NC}"
echo "(*) Worked on $(echo -n "$REPO_LIST" | wc -w) repository/s."
echo
read -n 1 -s -r -p "> Press any key to exit..."
