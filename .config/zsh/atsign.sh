#!/bin/bash
# atsign specific stuff

if ! command -v openssl &>/dev/null; then
  echo "openssl is required for atsign commands"
  return
fi

atdirectory() {
  head -n 1 < <(openssl s_client -connect root.atsign.org:64 -quiet -verify_quiet < <(echo "$1"; sleep 1; echo "@exit") 2>/dev/null)
}

atserver() {
  pkam_command="at_pkam"
  atsign="$1"
  if [[ ${atsign:0:1} != "@" ]] ; then 
    atsign="@$atsign"
  fi
  atkeys="$HOME/.atsign/keys/${atsign}_key.atKeys"
  time=$(date +%s)
  pipe="/tmp/atserver/$atsign-$time"

  mkdir -p "/tmp/atserver"
  mkfifo "$pipe"

  fqdn=$(atdirectory "${atsign:1}" | tr -d '\r\n\t ')
  if [ -f $atkeys ]; then
  # subshell to prevent the trap from leaking into the main shell
  (
    is_done=0
    _cleanup() {
      if [ $is_done -gt 0 ]; then
        return
      fi
      is_done=1
      rm "$pipe" 2>&1 >/dev/null
    }
    trap _cleanup INT TERM EXIT
    _pkam() {
      # Some sorcery to get the challenge to actually write to the openssl client
      # I think this tail flushes the pipe which is what allows us to write
      echo "from:$atsign"
      (tail -f "$pipe" &)
      tail_pid=$!
      challenge="$(head -n 1 $pipe)"
      echo "pkam:$($pkam_command -p $atkeys -r ${challenge:5})"
    }

    (_pkam && cat)  | (openssl s_client -brief -connect "${fqdn:1}") | tee "$pipe"
  )
  else
    # no atkeys file, don't try to pkam
    openssl s_client -brief -connect "${fqdn:1}" 
  fi
}
