# Everything starts with an empty repo
mkdir MyNewRepository
cd MyNewRepository
git init

# Use git status to find out more
git status

# Add a new file
New-Item NewScript.ps1

# Confirm that it is an untracked change
git status

# Add this file to the next commit (staging)
git add NewScript.ps1

# Commit your files to source control.
# Until now, nothing was tracked. once committed, changes will be tracked
git commit -m 'Added new script to do stuff'

# Verify with git status that the working copy is clean
git status

# Add a gitignore file that ignores all tmp files
New-Item .gitignore -Value '*.tmp'

# Stage and commit
git add .gitignore
git commit -m 'Added .gitignore file'

# Test the file. file.tmp should not appear when looking
# at the output of git status
New-Item file.tmp
git status