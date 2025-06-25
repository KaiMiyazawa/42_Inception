# Inception

This is one of the 42tokyo's projects. This repository is about a Docker lesson.

## Architecture

```mermaid
graph TB
    User[User Browser] -->|HTTPS:443| nginx[Nginx Container]
    nginx -->|FastCGI:9000| wordpress[WordPress-PHP Container]
    wordpress -->|MySQL:3306| mariadb[MariaDB Container]
    
    hostdata[/home/kmiyazaw/data/] --> database[database/]
    hostdata --> web[web/]
    
    database -.->|bind mount| mariadb_data[(mariadb_data)]
    web -.->|bind mount| wordpress_data[(wordpress_data)]
    
    mariadb_data --> mariadb
    wordpress_data --> wordpress
    wordpress_data --> nginx
    
    etchosts[/etc/hosts] -.->|DNS Resolution| User
    
    classDef container fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef volume fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef host fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    
    class nginx,wordpress,mariadb container
    class mariadb_data,wordpress_data volume
    class hostdata,database,web,etchosts host
```

**Components:**
- **Nginx**: Reverse proxy with SSL/TLS termination (port 443)
- **WordPress-PHP**: PHP-FPM server running WordPress (port 9000)
- **MariaDB**: Database server (port 3306)
- **Volumes**: Persistent data storage using bind mounts
- **Network**: Bridge network for inter-container communication

---

## Memo

- 各コンテナは、1つの作業に集中させるべき。
- Dockerfileの `CMD` では、フォアグラウンドで動くコマンドを指定する。  
  例: 
  ```dockerfile
  CMD ["nginx", "-g", "daemon off;"]
  CMD ["php-fpm7.4", "-F"]
  ```
- `kmiyazaw.42.fr` の名前解決を追加

---

## Review

- **起動手順:**
  - `make hosts`
  - `make`
- **クリーンアップ:**
  - `make down`
  - `make clean`

- **アクセスURL:**
  - [https://kmiyazaw.42.fr/](https://kmiyazaw.42.fr/) - 公開部分
  - [https://kmiyazaw.42.fr/wp-admin/](https://kmiyazaw.42.fr/wp-admin/) - ログインページ

---

### 説明事項

1. **DockerとDocker Composeの違い**
   - **Docker:**  
     コンテナを作成、管理するためのプラットフォーム。  
     コンテナはアプリケーションとその依存関係をパッケージ化したもので、Dockerイメージから作成され、実行や配布が可能です。
   - **Docker Compose:**  
     複数のコンテナを定義、実行するためのツール。  
     `docker-compose.yml` ファイルに各コンテナの設定を記述し、`docker-compose up` コマンドで一括してコンテナを起動します。

2. **VMと比較したDockerの利点**
   - 簡単に作成・破棄できる
   - 軽量で高速
   - 移動が容易

3. **Docker VolumeとDocker Networkの説明**
   - **Docker Volume:**  
     ホストマシンとコンテナ間でデータを共有する仕組みです。  
     コンテナ再起動後もデータが保持されます。  
     ※ VolumeはDockerが管理するデータの保存場所、Bind Mountはユーザが指定する保存場所です。
   - **Docker Network:**  
     コンテナ間で通信するための仕組みです。  
     利用可能なドライバは以下の通り:  
     - **bridge:** デフォルトで作成されるネットワーク 、同ネットワーク内のコンテナ同士で勝手にconectされる 
     - **host:** ホストマシンのネットワークをそのまま使用  
     - **overlay:** 複数のDockerデーモン間で通信  
     - **macvlan:** コンテナにMACアドレスを割り当てる  
     - **none:** ネットワークを使用しない

4. **Databaseにログインして中身を見る方法**
   - コンテナ内に入る:
     ```bash
     docker container exec -it mariadb bash
     ```
   - MySQLにログイン:
     ```bash
     mysql -u root -p
     ```
   - MySQL内での操作:
     ```sql
     show databases;
     use wordpress;
     show tables;
     select * from wp_users;
     ```
5. volumeの削除
    - `docker volume rm srcs_mariadb_data srcs_wordpress_data`
