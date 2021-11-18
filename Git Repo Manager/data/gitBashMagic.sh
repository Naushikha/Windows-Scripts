PROJECT_DIR=$1
GIT_COMMAND=$2
REPO_LIST=$3
REQUIRE_LOGIN=$4

echo -e "\t*** Git Repository Manager ***"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	echo "(!) SSH Login Required to Execute Command"
	echo "Starting SSH agent..."
	eval $(ssh-agent)
	ssh-add
fi

for REPO in $REPO_LIST
do
	echo 
	echo --------------------------------------------------
    echo ">>> $REPO"
	echo --------------------------------------------------
	cd $PROJECT_DIR
	cd $REPO
	eval ${GIT_COMMAND}
done

echo 
echo ==================================================
echo All done!
echo
read -n 1 -s -r -p "Press any key to exit..."
