#!/bin/bash
#Bash script to check the status of the git repo after all other tests are completed
export GIT_PAGER=cat  # Make sure git diff doesn't use less and hang...
# Reset the openmsistream/kafka_wrapper/config_files/ since the tests may have changed it, but that's okay
git checkout -- openmsistream/kafka_wrapper/config_files/
#Check for uncommitted changes
if ! [ -z "$(git status --porcelain)" ]
	then echo "tests created uncommitted changes"
	git status
	git diff
	git submodule foreach bash -c "git status; git diff"
	exit 1
fi
#Check for files chmodded to +x
chmod u-x $(find $(git ls-files) -maxdepth 0 -type f)
git diff --exit-code || (echo "The above files ^^^^^^ are chmodded to +x. This causes git status to show up as dirty on windows."; exit 1)
git submodule foreach bash -c 'chmod u-x $(find $(git ls-files) -maxdepth 0 -type f); git diff --exit-code || (echo "The above files ^^^^^^ are chmodded to +x.  This causes git status to show up as dirty on windows."; exit 1)'
exit 0
