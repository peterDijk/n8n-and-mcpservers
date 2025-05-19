import { create } from "./mcp-server.ts";
import { createSSEServer } from "./sse-server.ts";

const mcpServer = create();
const sseServer = createSSEServer(mcpServer);

sseServer.listen(process.env.PORT || 3002);
