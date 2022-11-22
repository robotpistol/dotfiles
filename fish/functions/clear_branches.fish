function clear_branches --description 'Deletes local branches that have been merged'
    set default_branch_name (basename (git symbolic-ref --short refs/remotes/origin/HEAD))
    set branch_names (git branch --merged=$default_branch_name | grep -v $default_branch_name)
    if test -n "$branch_names"
        echo "Pruning branches: $branch_names"
        echo $branch_names | xargs git branch -d
    else
        echo "no branches to prune"
    end
    git fetch --prune
end
