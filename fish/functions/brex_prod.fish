function brex_prod
  set pod $argv[1]
  if set -q argv[2]
    set command $argv[2..-1]
  else
    set command bash
  end
  brexec e-core-production $pod $command
end
