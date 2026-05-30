EAPI=8
inherit acct-user
DESCRIPTION="docker-updater user"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( docker-updater docker )
ACCT_USER_HOME=/storage/docker/docker-updater

acct-user_add_deps
