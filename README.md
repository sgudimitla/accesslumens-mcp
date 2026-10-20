# AccessLumens MCP server

[![npm](https://img.shields.io/npm/v/@accesslumens/mcp)](https://www.npmjs.com/package/@accesslumens/mcp) [![MCP Registry](https://img.shields.io/badge/MCP%20Registry-com.accesslumens%2Fmcp-blue)](https://registry.modelcontextprotocol.io/v0.1/servers?search=com.accesslumens/mcp)

Free accessibility checks for your AI coding agent. Ask it to scan the page you are building, and it gets back every WCAG problem with the exact element, the reason it fails and how to fix it. Then it fixes the code and scans again to confirm.

It runs the same scanner as [accesslumens.com](https://accesslumens.com/?utm_source=github&utm_medium=readme): axe-core plus AccessLumens' own checks for things axe does not test, such as controls you cannot reach by keyboard, keyboard traps, invisible focus and reflow at 320px.

Everything runs on your machine in a headless browser. It works on `localhost`, staging URLs, public sites and plain `.html` files. Nothing is sent to AccessLumens and no account or API key is needed.

## Setup

Requires Node.js 18.17 or later. AccessLumens scans in a headless Chromium, which it downloads once (about 150 MB). Download it now so your first scan does not wait on it:

```sh
npx -y @accesslumens/mcp install
```

Then add the server to your editor.

**Claude Code**

```sh
claude mcp add accesslumens -- npx -y @accesslumens/mcp
```

**Cursor** (`.cursor/mcp.json`), **Windsurf**, **Claude Desktop** and most other clients:

```json
{
  "mcpServers": {
    "accesslumens": { "command": "npx", "args": ["-y", "@accesslumens/mcp"] }
  }
}
```

**VS Code** (`.vscode/mcp.json`):

```json
{
  "servers": {
    "accesslumens": { "type": "stdio", "command": "npx", "args": ["-y", "@accesslumens/mcp"] }
  }
}
```

## Use it

Start your dev server, then run one of the ready-made workflows below, or just ask:

> Check http://localhost:3000/checkout for accessibility issues and fix them.

## Workflows (prompts)

Ready-made instructions that tell your agent not just what is wrong but how to fix it well: in the source, native HTML before ARIA, shared causes fixed once, design and behaviour unchanged, and every fix verified by a rescan. They appear as slash commands, for example `/mcp__accesslumens__fix-all` in Claude Code and `/mcp.accesslumens.fix-all` in VS Code. Each takes an optional `url`; leave it empty and the agent finds your dev server.

| Prompt | What it does |
| --- | --- |
| `fix-page` | Scans one page, fixes every issue in the source, rescans until no Critical or Serious issues remain, and lists what it changed. |
| `fix-all` | Two passes over every route in your app: fixes everything the scanner finds, then reviews the code for what scanners cannot detect (duplicate button names, focus in dialogs, route-change announcements, form errors, reduced motion). Rescans every route and reports scores before and after. |
| `audit` | The same review without changing any files: issues grouped by root cause, with the file each one comes from and an ordered fix plan. |

## Tools

| Tool | What it does |
| --- | --- |
| `check_accessibility` | Scans a URL, localhost address or local `.html` file. Returns a 0-100 score and each issue with its severity, WCAG success criteria, who it affects, how to fix it, and every failing element's selector, markup and failure reason. Options: `keyboard` (default on), `crawl` (follow links, up to 10 pages), `max_issues` (default 30). |
| `explain_issue` | Explains a rule from a scan result: what it means, who it affects, how to fix it, and the WCAG criteria with W3C links. |

## Docker

The image bundles Chromium, so it scans with no download:

```sh
docker build -t accesslumens-mcp .
docker run -i --rm accesslumens-mcp
```

A container cannot reach `localhost` on your machine by default. To scan a local dev server from Docker, use `http://host.docker.internal:3000` (Docker Desktop) or run with `--network host` (Linux). For local work, `npx` is simpler.

## Good to know

- Automated testing finds roughly a third of WCAG issues. A clean scan is a good start, not proof of conformance. Issues marked "needs human review" need a person to confirm.
- Sites behind bot protection (Cloudflare and similar) can block headless browsers. Scan a local or staging copy instead.
- Set `ACCESSLUMENS_DEBUG=1` to log scanner detail to stderr.

## Full reports and PDFs

For a shareable report with your legal context (ADA, EAA, Section 508), multi-page journeys through signed-in flows, and PDF accessibility checks and repair, see [accesslumens.com](https://accesslumens.com/?utm_source=github&utm_medium=readme).

## License

Free to use, including commercially. Redistribution and resale are not permitted. See [LICENSE](LICENSE).

## About this repository

The server ships as the npm package [`@accesslumens/mcp`](https://www.npmjs.com/package/@accesslumens/mcp). This repository holds its directory listing (`server.json`, `glama.json`) and the Dockerfile, and is the place for questions, bug reports and feature requests: [open an issue](../../issues) or write to support@accesslumens.com.
