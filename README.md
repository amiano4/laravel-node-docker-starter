# Laravel + Vue (Vite) Docker Development Environment

## Architecture Overview

This repository provides a robust, containerized local development environment for a Laravel API backend and a Vue (Vite-based) frontend. Each app lives in its own directory under `app/` and is managed independently. All Docker configuration is centralized in the `docker/` directory, and SSL certificates are stored in `certs/`.

**Directory Structure:**

```
app/
  backend/    # Laravel project (served by Nginx + PHP-FPM)
  frontend/   # Vue (Vite) project (served by Vite/pnpm)
certs/        # Local SSL certs (mkcert/self-signed)
docker/
  nginx/
    # Server setup
  php/
    # PHP build and configurations
  node/
    # Node.js build and persistence
  mysql/
    my.cnf # Override default MySQL configs
.env           # Environment variables
Makefile       # Common dev commands
docker-compose.yml  # Main Docker Compose file
.gitignore     # Ignores build artifacts, secrets, and dependencies
```

**Services Provided:**

- **Nginx**: Serves Laravel directly (not via PHP built-in server)
- **PHP 8.3**: Runs Laravel (with Composer installed)
- **node_app (Node 20 + pnpm)**: Runs Vue frontend (with hot reload and pnpm cache)
- **MySQL**: Database for Laravel
- **Redis**: Cache/queue for Laravel
- **Mailhog**: Local email testing
- **PhpMyAdmin**: MySQL web UI

## Setup Instructions

### 1. Clone the Repository

```
git clone https://github.com/amiano4/laravel-vue-docker-based-boilerplate.git
cd laravel-vue-docker-based-boilerplate
# Don't forget to rename your template
```

### 2. Configure Environment Variables (Optional)

- Update necesasry ports and other configurations

### 3. Generate/Acquire Local SSL Certificates (Optional)

- Use [mkcert](https://github.com/FiloSottile/mkcert) or OpenSSL to generate local certificates.
- Place them in the `certs/` directory.
- If you have successfully acquired SSL Certificates, you may set `USE_HTTPS=true` in the `env` file to take effect

### 4. Add Your Applications

- Place your **Laravel** project in `app/backend`.
- Place your **Vue (Vite)** project in `app/frontend`.
- If you don't have projects yet, you can scaffold them:

  ```bash
  # Laravel project
  make shell-php
  laravel new backend .

  # Vue project
  make shell-node
  pnpm create vue@latest .
  ```

### 5. Start the Development Environment

```
make up
```

- This builds and starts all containers.

### 6. Access Your Apps

- If no errors encountered during initialization you will see something like this:

  🔗 Laravel API: http://localhost:8000

  🔗 App (Vue.js): http://localhost:5173

  🔗 phpMyAdmin: http://localhost:8080

  🔗 Mailhog: http://localhost:8025

## Usage & Common Commands

- `make up` — Start all containers (build if needed)
- `make down` — Stop all containers
- `make restart` — Restart all containers
- `make reset` — ⚠️ Stop and rebuild everything, including named volumes (resets DB, Redis, etc.)
- `make logs` — Tail logs from all containers
- `make shell-php` — Shell into the PHP container
- `make shell-node` — Shell into the Node container
- `make shell-mysql` — Shell into the MySQL container
- `make shell-redis` — Shell into the Redis container

## Troubleshooting

### Docker Build Issues

- **Port conflicts**: Change the relevant port in `.env` if a service fails to start due to a port already in use.

- **Inaccessible Frontend (Vue) App in HTTPS**: Update your vite.config.js to use `https`:

  ```js
  // vite.config.js

  // the original USE_HTTPS variable
  const useHttps = process.env.ENV_USE_HTTPS === 'true'

  // in your defineConfig ...
  server: {
    https: useHttps ? {
      key: fs.readFileSync('/certs/server.key'),
      cert: fs.readFileSync('/certs/server.crt'),
    } : undefined,
    host: true,
    port: 5173, // This is not your FRONTEND_PORT
  },
  // ...
  ```

  Clear you browser cached, restart the docker containers, try manual `pnpm install`.

### Application Issues

- **Laravel not serving**: Ensure `.env` and `storage/` permissions are correct in `app/backend`.
- **Frontend not hot-reloading**: Make sure your source code is mounted and Vite is running in dev mode.
- **Database connection errors**: Check MySQL credentials in `.env` and ensure the `mysql` service is healthy.

## Customization & Extending

- **PHP Extensions**: Add more extensions in `docker/php/Dockerfile` as needed.
- **MySQL Config**: Place overrides in `docker/mysql/my.cnf`.
- **pnpm Cache**: The pnpm cache is persisted using a volume mapped to `docker/node/.pnpm_store` for faster dependency installs.
- **Redis Data**: Redis data is persisted in `docker/redis/data` (make sure this directory exists or is created by Docker).

## FAQ

**Q: Can I use this for production?**
A: This setup is optimized for local development. For production, you should build optimized images and use a production-grade web server and SSL setup.

**Q: How do I add more services?**
A: Add them to `docker-compose.yml` and create any needed config in `docker/`.

**Q: How do I reset the database or cache?**
A: Run `make reset` (removes containers and named volumes), then `make up` to recreate.

## Credits

- I'm just learning docker.
