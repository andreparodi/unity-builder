#!/usr/bin/env bash
# some debug
git config -l --show-origin
#echo "username:  $GITHUB_USERNAME"
#echo "pat:  $GITHUB_PERSONAL_ACCESS_TOKEN"
#git config --global url."https://abcd:$GITHUB_PERSONAL_ACCESS_TOKEN@github.com/".insteadOf "https://github.com/"
git config -l --show-origin
#git config --local --unset-all 'http.https://github.com/.extraheader'

echo "======Trying https"
GIT_TRACE=2 GIT_CURL_VERBOSE=2 GIT_TRACE_PERFORMANCE=2 GIT_TRACE_PACK_ACCESS=2 GIT_TRACE_PACKET=2 GIT_TRACE_PACKFILE=2 GIT_TRACE_SETUP=2 GIT_TRACE_SHALLOW=2 git ls-remote "https://github.com/bn-mobile/UP_GitVersioning.git"

echo "======Adding insteadof"
git config --global url."ssh://git@github.com/".insteadOf "https://github.com/"

echo "======Trying https"
GIT_TRACE=2 git ls-remote "https://github.com/bn-mobile/UP_GitVersioning.git"

echo "======= try git with ssh explicit"
GIT_TRACE=2 git ls-remote "ssh://git@github.com/bn-mobile/UP_GitVersioning.git"

echo "======== try git with git no protocol"
GIT_TRACE=2 git ls-remote "git@github.com/bn-mobile/UP_GitVersioning.git"

echo "try ssh"
ssh -vvv -o "BatchMode yes" git@github.com who
echo "======known hosts"
cat /root/.ssh/known_hosts
#
# Create directory for license activation
#

ACTIVATE_LICENSE_PATH="$GITHUB_WORKSPACE/_activate-license"
mkdir -p "$ACTIVATE_LICENSE_PATH"

#
# Run steps
#

source /steps/activate.sh
source /steps/build.sh
source /steps/return_license.sh

#
# Remove license activation directory
#

rm -r "$ACTIVATE_LICENSE_PATH"

#
# Instructions for debugging
#

if [[ $BUILD_EXIT_CODE -gt 0 ]]; then
echo ""
echo "###########################"
echo "#         Failure         #"
echo "###########################"
echo ""
echo "Please note that the exit code is not very descriptive."
echo "Most likely it will not help you solve the issue."
echo ""
echo "To find the reason for failure: please search for errors in the log above."
echo ""
fi;

#
# Exit with code from the build step.
#

exit $BUILD_EXIT_CODE
