# n8n with PostgreSQL and test MCP server

Starts n8n with PostgreSQL as database.
Starts a demo MCP server to connect n8n with it. The MCP server has some basic tool for getting weather forecast using https://api.weather.gov

To verify MCP server is up and running ok, use the MCP Inspector https://modelcontextprotocol.io/docs/tools/inspector
To run: `npx @modelcontextprotocol/inspector`

The MCP server is running in docker internally on host `test-mcp-server` port `3002`.
To connect from n8n, use URL: http://test-mcp-server:3002/mcp
Transport type: Streamable HTTP.

## Start

To start n8n with PostgreSQL simply start docker-compose by executing the following
command in the current folder.

**IMPORTANT:** But before you do that change the default users and passwords in the [`.env`](.env) file!

```
docker-compose up -d
```

n8n is available on port `5678`

To stop it execute:

```
docker-compose stop
```

## TODO

- [x] store the postgres data in the project root, so that the n8n workflows are available for everybody. Trying in PR: https://github.com/peterDijk/n8n-and-mcpservers/pull/4

## Configuration

To create a db dump from current database state:

Get into the container:
`docker compose exec -it postgres bash`

Make the dump:
`pg_dump -U changeUser n8n > /var/lib/postgresql/data/[filename].sql`

Exit the container: `exit`

Copy the file from the container to our project root:
`dc cp postgres:/var/lib/postgresql/data/[filename].sql ./postgres_db_dumps/[filename].sql`

Done, file is now in the `postgres_db_dumps` folder
