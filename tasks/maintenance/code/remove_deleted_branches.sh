git branch -vv

echo "Deleting:"
git branch -vv | grep ': gone]'| grep -v "\*" | awk '{ print $1; }'

git branch -vv | grep ': gone]'| grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D

