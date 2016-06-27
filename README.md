# server-provisions

Script architecture for creating predefined provisioning scripts. I know
that there are other (ie. Puppet) but why not do it on my own and learn
something :)

Structure:
```
project
│
├─ common (Common scripts that are loaded globally)
│    ├─ base.sh
│    └─ template.sh
│
├─ manifests
│    ├─ nginx
│    │    ├─ configs
│    │    │    └─ codeigniter.conf
│    │    └─ sites
│    │          └─ sample
│    ├─ adminer.sh
│    ├─ environment.sh
│    ├─ git.sh
│    ├─ mysql.sh
│    ├─ nginx.sh
│    ├─ nodejs.sh
│    ├─ php.sh
│    ├─ tools.sh
│    └─ template.sh
│
├─ provisions
│    └─ default.sh
│
└─ tests
      └─ test.php
```