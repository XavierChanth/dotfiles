# Local configuration

Pretty much everything here is about setting up files which shouldn't be tracked
by git. Thus manual setup is the way, sure, I could store these somewhere, but
ideally, I'm not configuring these things often. Knock on wood.

## Setup your ssh keys

- Generate your ssh keys
- Upload to git/ssh servers
- Add additional ssh hosts to `~/.ssh/config.d/`

## Setup gmail with aerc

Variables:

- ACCOUNT: An account name which should be kept consistent for mapping
- USER: This could be a partial email such as `alice` for `alice@gmail.com` or
  the full email in the case of `alice@acme.com`
- EMAIL: The email address
- FULL NAME: The display name when sending mail
- DISPLAY NAME: Name of the account that shows up in aerc tabs
- APP PASSWORD: The app password generated in Google's security settings

> Many accounts may need to be configured so I'm using `personal` as a
> placeholder in many places as well

### Create your maildir(s)

```
mkdir -p ~/mail/personal
```

### Setup aerc

Setup `~/.config/aerc/accounts.conf` like so:

```
[{DISPLAY NAME}]
source              = notmuch://~/mail/personal/
check-mail-cmd      = ~/.local/bin/syncmail personal
check-mail          = 5m
outgoing            = ~/.local/bin/sendmail {ACCOUNT}
query-map           = ~/.config/aerc/map.conf
maildir-store       = .
multi-file-strategy = act-all
from                = {NAME} <{EMAIL}>
# aliases             = <OPTIONAL>
default             = INBOX
archive             = ARCHIVE
copy-to             = SENT
```

### Setup keychain

Make sure to add app specific password to the keychain, you must create this
through Google's portal (This must match the `user` configured in msmtp config):

```
# macos
security add-internet-password -s smtp.gmail.com -r smtp -a <USER> -w
security add-internet-password -r imap -s imap.gmail.com -a <USER> -w
```

### Receiving (IMAP)

Setup `~/.notmuch-config` like so:

> Make sure to set maildir to an absolute path

```
[database]
path=/HOME/PATH/mail/personal
[user]
primary_email=<EMAIL>
[new]
[search]
exclude_tags=deleted;spam;
[maildir]
synchronize_flags=true
```

Setup `~/.mbsyncrc` like so:

```
IMAPAccount <ACCOUNT>
Host imap.gmail.com
Port 993
User <USER>
UseKeychain yes
TLSType IMAPS

IMAPStore personal-remote
Account <ACCOUNT>

MaildirStore personal-local
Path ~/mail/personal/
Inbox ~/mail/personal/INBOX/
Subfolders Verbatim

Channel personal-sent
Far :personal-remote:"[Gmail]/Sent Mail"
Near :personal-local:"SENT"
Create Both
Expunge Both
SyncState *

Channel personal-all
Far :personal-remote:"[Gmail]/All Mail"
Near :personal-local:"ARCHIVE"
Create Both
Expunge Both
SyncState *

Channel personal-rest
Far :personal-remote:
Near :personal-local:
Create Both
Expunge Both
Patterns * !"[Gmail]/Important" !"[Gmail]/Starred" !"[Gmail]/Bin" !"[Gmail]/All Mail" !"ARCHIVE" !"SENT"
SyncState *

Group personal
Channel personal-sent
Channel personal-all
Channel personal-rest
```

### Sending (SMTP)

Setup `~/.config/msmtp/config` like so:

```
account <ACCOUNT>
user <USER>
from <EMAIL>
from_full_name <FULL NAME>
host smtp.gmail.com
port 465
tls on
tls_starttls off
auth on
```
