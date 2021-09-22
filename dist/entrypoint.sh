#!/usr/bin/env bash
# some debug
git config -l --show-origin
echo "username:  $GITHUB_USERNAME"
echo "pat:  $GITHUB_PERSONAL_ACCESS_TOKEN"
git config --global url."https://$GITHUB_USERNAME:$GITHUB_PERSONAL_ACCESS_TOKEN@gibberish.com/".insteadOf "https://github.com/"
git config -l --show-origin
git config --local --unset-all 'http.https://github.com/.extraheader'
GIT_TRACE=2 GIT_CURL_VERBOSE=2 GIT_TRACE_PERFORMANCE=2 GIT_TRACE_PACK_ACCESS=2 GIT_TRACE_PACKET=2 GIT_TRACE_PACKFILE=2 GIT_TRACE_SETUP=2 GIT_TRACE_SHALLOW=2 git ls-remote "https://github.com/bn-mobile/UP_GitVersioning.git"


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
