# Easy navigation of repositories
# If a given repo is checked out go to that directory
# If the repo directory does not exist, checkout the repo to that directory.
function g
  set repo_root ~/src
  set github_uri github.com

  # default org and repo values
  # run `set -Ux DOTFILES_ORG_NAME <org_name>` to change default
  if set -q $DOTFILES_ORG_NAME
    set org $DOTFILES_ORG_NAME
  else
    set org veyond-card
  end

  # run `set -Ux DOTFILES_REPO_NAME <org_name>` to change default
  if set -q $DOTFILES_REPO_NAME
    set repo $DOTFILES_REPO_NAME
  end

  # If handle parameters
  if set -q argv[1]
    # Split on / to get the org and repo parts
    set parts (string split "/" -- $argv[1])

    # if there's only 1 item, then it's assumed to be the repo fill in a smart default
    if test (count $parts) = 1
      set repo $parts[1]
    else # otherwise use the first 2 parts
      set org $parts[1]
      set repo $parts[2]
    end
  end

  # set our working variables
  set org_dir "$repo_root/$org"
  set tgt "$org_dir/$repo"
  set repo_uri "git@$github_uri:$org/$repo"

  # Try to go to the directory
  cd "$tgt" 2>/dev/null
  if test $status != 0
    # if that failed then try see if the github repo exists
    git ls-remote $repo_uri >/dev/null 2>&1
    if test $status = 0
      # If we found a repo, make the org directory and check it out.
      mkdir -p $org_dir
      # change directory to the org directory so that we can clone there rather than cwd
      cd $org_dir
      # clone the target repo
      git clone $repo_uri
      cd "$tgt"
    else
      echo "Could not find git repo $repo_uri"
    end
  end
end
