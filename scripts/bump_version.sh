#!/bin/sh
if [ -z "$1" ]
  then
    echo "No version are provided"
    exit 1
fi

#if [ -z "$2" ]
#  then
#    echo "No new version are provided"
#    exit 1
#fi

if [ ! -f VERSION ]
  then
    echo "Could not find a VERSION file. Creating one."
    touch VERSION
fi


if [ ! -f CHANGELOG ]
  then
    echo "Could not find a CHANGELOG file. Creating one."
    touch CHANGELOG
fi

CURRENT_VERSION=`cat VERSION`
#CURRENT_VERSION="$1"
NEW_VERSION="$1"
DATE=`date +"%Y-%m-%d"`

if [ "$CURRENT_VERSION" != "" ]
then
	if ! git show-ref --tags | egrep -q "refs/tags/${CURRENT_VERSION}$"
    then
        echo "Current version tag ${CURRENT_VERSION} not found"
        exit 1
    fi
fi

echo "Current version : $CURRENT_VERSION"
echo "New version : $NEW_VERSION"

echo "$NEW_VERSION ($DATE)" > tmpfile
echo "-------------------" >> tmpfile

if [ "$CURRENT_VERSION" == "" ]
then
	git log --no-merges --pretty=format:" * %s" >> tmpfile
else
	git log --no-merges --pretty=format:" * %s" "$CURRENT_VERSION"..HEAD >> tmpfile
fi


echo "" >> tmpfile
echo "" >> tmpfile
cat CHANGELOG >> tmpfile

echo "CHANGELOG:"
more tmpfile

read -p "Do you want to create files? " -n 1 -r
echo    # (optional) move to a new line


if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "VERSION set to $NEW_VERSION"
    echo $NEW_VERSION > VERSION
    mv tmpfile CHANGELOG
    echo "CHANGELOG updated!"
    rm -f tmpfile
fi


read -p "Do you want to create the release branch? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git checkout -b release-${NEW_VERSION}
    git add -A
    git commit -m "RELEASE ${NEW_VERSION}"

fi

read -p "Do you want to merge to master? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git checkout master
    git merge --no-ff release-"$NEW_VERSION" -m "VERSION  ${NEW_VERSION}"
    echo "Release branch merged!"
fi

read -p "Do you want to relase gem? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

    echo "New version released!"
fi


rm -f tmpfile
