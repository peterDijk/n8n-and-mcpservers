# n8n with PostgreSQL and test MCP server

Starts n8n with PostgreSQL as database.
Starts a demo MCP server to connect n8n with it. The MCP server has some basic tool for getting weather forecast using https://api.weather.gov

To verify MCP server is up and running ok, use the MCP Inspector https://modelcontextprotocol.io/docs/tools/inspector
To run: `npx @modelcontextprotocol/inspector`

The MCP server is served by docker on port 3000.
Transport type: Streamable HTTP.
URL: http://localhost:3000/mcp

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

- [ ] store the postgres data in the project root, so that the n8n workflows are available for everybody. Trying in PR: https://github.com/peterDijk/n8n-and-mcpservers/pull/4
- [ ] setup nginx to serve n8n. Allows us to disable gzip compression what is apparently needed to be able to connect

## Configuration

The default name of the database, user and password for PostgreSQL can be changed in the [`.env`](.env) file in the current directory.
