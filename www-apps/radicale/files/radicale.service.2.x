[Unit]
Description = A simple CalDAV (calendar) and CardDAV (contact) server
After = network.target
Requires = network.target

[Service]
ExecStart=/usr/bin/env python3 -m radicale --foreground --config /etc/radicale/config --logging-config /etc/radicale/logging -D
Restart = on-failure
User = radicale
UMask = 0027
PrivateTmp = true
ProtectSystem = strict
ProtectHome = true
PrivateDevices = true
ProtectKernelTunables = true
ProtectKernelModules = true
ProtectControlGroups = true
NoNewPrivileges = true
ReadWritePaths = /var/lib/radicale/collections
[Install]
WantedBy = multi-user.target
