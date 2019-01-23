function g
  if not set -q argv[1]
    set argv[1] veyond-card/credit_card
  end

  switch $argv[1]
    case '*/*'
      set repo $argv[1]
    case '*'
      set repo veyond-card/$argv[1]
  end

  set tgt ~/src/"$repo"
  set repo_uri git@github.com:$repo

  if not test -d $tgt
    git clone -v $repo_uri "$tgt"
  end

  cd "$tgt"
end
