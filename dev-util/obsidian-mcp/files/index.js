import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import axios from "axios";

const API_KEY = process.env.OBSIDIAN_API_KEY;
const API_HOST = process.env.OBSIDIAN_API_HOST || "http://localhost:27124";

const client = axios.create({
  baseURL: API_HOST,
  headers: {
    Authorization: `Bearer ${API_KEY}`,
    "Content-Type": "application/json",
  },
});

const server = new Server(
  { name: "obsidian-custom-sidecar", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "read_note",
        description: "Read a note from the Obsidian vault",
        inputSchema: {
          type: "object",
          properties: {
            path: { type: "string", description: "Path to the markdown file" },
          },
          required: ["path"],
        },
      },
      {
        name: "list_notes",
        description: "List notes in the vault",
        inputSchema: {
          type: "object",
          properties: {
            path: { type: "string", description: "Folder path to list" },
          },
        },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;
  try {
    switch (name) {
      case "read_note": {
        const response = await client.get(`/vault/${args.path}`);
        return { content: [{ type: "text", text: response.data }] };
      }
      case "list_notes": {
        const path = args.path || "";
        const response = await client.get(`/vault/${path}`);
        return { content: [{ type: "text", text: JSON.stringify(response.data, null, 2) }] };
      }
      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error) {
    return {
      content: [{ type: "text", text: `Error: ${error.response?.data || error.message}` }],
      isError: true,
    };
  }
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(console.error);
