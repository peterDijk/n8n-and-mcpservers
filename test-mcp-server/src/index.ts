import { create } from "./mcp-server.ts";
import { createSSEServer } from "./sse-server.ts";
import { createStreamHttpServer } from "./stream-http-server.ts";

const mcpServer = create();
// const sseServer = createSSEServer(mcpServer);
const streamableHttpServer = createStreamHttpServer(mcpServer);

streamableHttpServer.listen(process.env.PORT || 3002);
