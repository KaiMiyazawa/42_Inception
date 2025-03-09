#!/bin/sh
set -eu

echo "===> MARIADB_DB_NAME is '${MARIADB_DB_NAME:-}'"

# 1) まだ初期化されていないかチェック
#   /var/lib/mysql/mysql というディレクトリが存在しなければ、DB未初期化とみなす
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "===> MariaDB is not initialized. Initializing..."
    mysql_install_db
else
    echo "===> MariaDB is already initialized."
fi

# 2) init.sql のテンプレートを環境変数展開し、最終ファイルを上書き
envsubst < /etc/mysql/init.sql.template > /etc/mysql/init.sql

# 3) MariaDBサーバを起動 (init_fileで /etc/mysql/init.sql を読み込み)
echo "===> Starting mysqld..."
exec "$@"