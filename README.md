# IDP Scheduler Self-Hosted Supabase

This is the Docker Compose setup for the [IDP Scheduler](https://github.com/LarryLing/IDP-Scheduler) frontend application. Follow the steps below to get started.

## Getting Started

### Dependencies

Please ensure you have [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed.

### Installing

Clone the repo
```sh
git clone https://github.com/LarryLing/IDP-Scheduler-Self-Hosted-Supabase.git
```

### Editing Environment Variables

1. Create a `.env` file and copy the contents of `.env.example`.
2. Enter secure passwords for `POSTGRES_PASSWORD` and `DASHBOARD_PASSWORD`. You may also optionally edit the `DASHBOARD_USERNAME`.
3. Use the following [link](https://supabase.com/docs/guides/self-hosting/docker#generate-api-keys) to get a `JWT_SECRET` and generate keys for `ANON_KEY` and `SERVICE_ROLE_KEY`. Remember the `ANON_KEY` for the frontend application.

![Generate keys](https://github.com/LarryLing/IDP-Scheduler-Self-Hosted-Supabase/blob/main/screenshots/generate_keys.png "Generate keys")

### Working With Containers

If the container is being run for the very first time or the database needs to be reset, copy the following commands
```sh
docker compose pull
docker compose up -d
docker exec -i $(docker compose ps -q db) psql -U postgres -d postgres < schema.sql
docker exec -i $(docker compose ps -q db) psql -U postgres -d postgres < seed.sql
```

Otherwise, use the following command
```sh
docker compose up -d
```

To temporarily pause the container, use the following command
```sh
docker compose stop
```

To halt and remove the container, use the following command
```sh
docker compose down
```

### Accessing Dashboard

You can access the Supabase dashboard with the following URL: [http://localhost:8000](http://localhost:8000)

You will then be prompted to login. Enter your `DASHBOARD_USERNAME` and `DASHBOARD_PASSWORD` to continue.
