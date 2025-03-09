# Inception
This is one of the 42tokyo's projects. this repository is about a Docker-lesson.


# memo
各コンテナは、1つの作業に集中させるべき。
なので、DockerfileのCMDでは、フォアグラウンドで動くコマンドを指定する。
ex. `CMD ["nginx", "-g", "daemon off;"]`, `CMD ["php-fpm8.2", "-F"]`

- kmiyazaw.42.frの名前解決を追加

# review
- first, `make hosts`
- second, `make`
- to clean, `make down`, `make clean`
- https://kmiyazaw.42.fr/
    - 公開部分
- https://kmiyazaw.42.fr/wp-admin/
	- ログインページ
