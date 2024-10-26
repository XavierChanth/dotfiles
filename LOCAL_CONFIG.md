# Local configuration

## Gmail with aerc

Setup `~/.config/msmtp/config` like so:

```
account <ACCOUNT>
user <ACCOUNT>
from <EMAIL>
from_full_name <FULL NAME>
host smtp.gmail.com
port 465
tls on
tls_starttls off
auth on
```

Make sure to add app specific password to the keychain, you must create this
through Google's portal (This must match the `user` configured in msmtp config):

```
# macos
security add-internet-password -s smtp.gmail.com -r smtp -a <ACCOUNT> -w
```

Setup `~/.config/aerc/accounts.conf` like so:

```
[{DISPLAY NAME}]
source          = imaps://{EMAIL}:{APP PASSWORD}@imap.gmail.com:993
outgoing        = ~/.local/bin/sendmail {ACCOUNT}
default         = INBOX
from            = {NAME} <{EMAIL}>
cache-headers   = true
use-gmail-ext   = true
archive         = [Gmail]/All Mail
folders-exclude = Archive
```
