# Backup script defaults:
#
default["backup"]["backup_script_path"] = "/usr/local/bin"
default["backup"]["aws_access_key_id"] = "Set in as part of role"
default["backup"]["aws_secret_access_key"] = "Set as part of role"
default["backup"]["passphrase"] = "Set as part of role"
default["backup"]["dest"] = "~/backups"
default["backup"]["gpg_key"] = "Set as part of role"
default["backup"]["root"] = "/"

# Todo:
# INCLIST
# EXCLIST
# LOG_FILE_OWNER = "root:root"

# Mysql backup script defaults
#
default["backup"]["databases"] = "all"

