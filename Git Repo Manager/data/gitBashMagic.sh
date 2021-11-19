PROJECT_DIR=$1
GIT_COMMAND=$2
REPO_LIST=$3
REQUIRE_LOGIN=$4

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
echo -e -n "> Working Project Directory: \n\t"
echo $PROJECT_DIR
echo
echo -e -n "> Running Git Command: \n\t"
echo $GIT_COMMAND
echo
echo "> Selected Repository List:"
for REPO in $REPO_LIST
do
	echo -e -n "\t"
    echo $REPO
done

if [ $REQUIRE_LOGIN -eq 1 ]
then
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

echo 
echo ==================================================
echo "${YELLOW}(!) All done!${NC}"
echo
read -n 1 -s -r -p "> Press any key to exit..."
