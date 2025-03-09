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
exec mysqld



##!/bin/bash
#echo "===> MARIADB_DB_NAME is '$MARIADB_DB_NAME'"

#if [ ! -d "/var/lib/mysql/mysql" ]; then
#	# /etc/mysql/init.sqlに環境変数を展開
#	envsubst < /etc/mysql/init.sql > /tmp/init.sql
#	mv /tmp/init.sql /etc/mysql/init.sql
#	rm -f /tmp/init.sql

#    mysql_install_db

#    # 一時起動 (grantテーブルをスキップしない)
#    mysqld --skip-networking --socket=/tmp/mysqld.sock &
#    while ! mysqladmin --socket=/tmp/mysqld.sock ping --silent; do
#        sleep 1
#    done

#    # init.sql を読み込む (ここで CREATE USER, GRANT が使える)
#    mysql --socket=/tmp/mysqld.sock < /etc/mysql/init.sql

#    # 一時起動を停止
#    mysqladmin --socket=/tmp/mysqld.sock shutdown
#fi

## 最後に通常起動
#exec mysqld
