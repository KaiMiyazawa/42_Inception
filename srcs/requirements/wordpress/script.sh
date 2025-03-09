#!/bin/bash

# --- [追加] WP-CLI キャッシュ用ディレクトリを作成し、/var/www 全体を www-data に変更 ---

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

mkdir -p /var/www/.wp-cli/cache
chown -R www-data:www-data /var/www/.wp-cli

cd /var/www/html

# --- 1) WP-CLIがまだ無い場合のみダウンロード ---
if [ ! -f wp-cli.phar ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    chown www-data:www-data wp-cli.phar
fi

# --- 2) 既にWordPressがインストール済みかをチェック ---
if sudo -u www-data -- php wp-cli.phar core is-installed 2>/dev/null; then
    echo "WordPressはすでにインストールされています。インストール処理をスキップします。"
else
    echo "WordPressが未インストールのため、インストールを実行します。"

    # WordPress本体ダウンロード
    sudo -u www-data -- php wp-cli.phar core download

    # wp-config.php の生成
    sudo -u www-data -- php wp-cli.phar config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${MARIADB_HOST}"

    # WordPressのインストール
    sudo -u www-data -- php wp-cli.phar core install \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}"

    # ユーザー作成（エディター）
    sudo -u www-data -- php wp-cli.phar user create "${WORDPRESS_USER1_USER}" "${WORDPRESS_USER1_EMAIL}" \
        --role=${WORDPRESS_USER1_ROLE} \
        --user_pass="${WORDPRESS_USER1_PASSWORD}"

    echo "WordPressのインストールが完了しました。"
fi

# --- 3) PHP-FPMをフォアグラウンドで起動 ---
exec "$@"
