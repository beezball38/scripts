# Set error action to stop on any errors
$ErrorActionPreference = "Stop"

# Prompt the user to confirm branch deletion
$confirmation = Read-Host "Are you sure you want to delete your current branch and make a new one from master? (y/n)"

if ($confirmation -ne 'y') {
    Write-Host "Operation cancelled."
    return
}

# Prompt for the name of the new branch
$newBranchName = Read-Host "Enter the name for the new branch"

# Get current branch name
$currentBranch = git rev-parse --abbrev-ref HEAD

# Switch to the master branch
Write-Host "Switching to master branch..."
git checkout master

# Update master branch
Write-Host "Updating master branch..."
git pull origin master

# Delete the local branch
Write-Host "Deleting local branch '$currentBranch'..."
git branch -D $currentBranch

# Delete remote branch if exists
Write-Host "Deleting remote branch '$currentBranch' if exists..."
git push origin --delete $currentBranch 2>$null

# Create new branch
Write-Host "Creating a new branch with the name '$newBranchName'..."
git checkout -b $newBranchName

Write-Host "Done!"
