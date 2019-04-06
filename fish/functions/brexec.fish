#!/usr/bin/env bash

# brexec [KUBE NS] [POD] [KUBECTL ARGUMENTS]? [COMMAND]
#
# Run a command on a k8s pod. Picks the *youngest* pod whose name
# contains the substring "-core-$POD".
#
# Usage examples:
# $ ./brexec e-core-staging api ls # note that no arguments are needed to run non-interactive commands
# $ ./brexec e-core-staging api -it bash # note the '-it' needed to run bash
# $ ./brexec e-core-staging database-postgres "pg_dump | gzip -c" > staging.pgdump.sql.gz # note the double quotes to pass a complex command

function brexec
  set -x NS $argv[1]
  set -x POD $argv[2]

  set flags "-it"
  set command $argv[3..-1]

  set pod (kubectl -n $NS get pods --sort-by="{.metadata.creationTimestamp}" \
          | grep -- Running \
          | grep -- $POD \
          | cut -d ' ' -f 1 \
          | tail -n 1)

  kubectl exec -n $NS $flags $pod -- bash -c "$command"
end
