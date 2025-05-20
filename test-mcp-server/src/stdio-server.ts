import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { create } from "./mcp-server.ts";

async function main() {
  const mcpServer = create();
  const transport = new StdioServerTransport();
  await mcpServer.connect(transport);
  console.error("Weather MCP Server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error in main():", error);
  process.exit(1);
});
