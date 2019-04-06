function gpr
  set branch (git name-rev --name-only HEAD)
  if set -q argv[1]
    set branch $argv[1]
  end
  git pull --rebase origin $branch
end
