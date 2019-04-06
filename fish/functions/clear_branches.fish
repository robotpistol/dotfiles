function clear_branches --description 'Deletes local branches that have been merged'
  git branch --merged=master | grep -v master | xargs git branch -d
  git fetch --prune
end
