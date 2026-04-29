import re

with open("synapse-1.150.0.ebuild", "r") as f:
    content = f.read()

with open("crates_new.txt", "r") as f:
    new_crates = f.read()

# Replace CRATES block
content = re.sub(r'CRATES="\n.*?^"', new_crates, content, flags=re.MULTILINE | re.DOTALL)

# Update IUSE
# Existing: IUSE="postgres selinux systemd test"
content = re.sub(r'IUSE=".*?"', 'IUSE="ldap oidc postgres redis saml2 selinux systemd test workers"', content)

with open("synapse-1.150.0.ebuild", "w") as f:
    f.write(content)
