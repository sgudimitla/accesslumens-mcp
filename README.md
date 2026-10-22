# AccessLumens MCP server

[![npm](https://img.shields.io/npm/v/@accesslumens/mcp)](https://www.npmjs.com/package/@accesslumens/mcp) [![MCP Registry](https://img.shields.io/badge/MCP%20Registry-com.accesslumens%2Fmcp-blue)](https://registry.modelcontextprotocol.io/v0.1/servers?search=com.accesslumens/mcp)

Free accessibility checks for your AI coding agent. Ask it to scan the page you are building, and it gets back every WCAG problem with the exact element, the reason it fails and how to fix it. Then it fixes the code and scans again to confirm.

It runs the same scanner as [accesslumens.com](https://accesslumens.com/accessibility-mcp-server?utm_source=github&utm_medium=readme): axe-core plus AccessLumens' own checks for things axe does not test, such as controls you cannot reach by keyboard, keyboard traps, invisible focus, reflow at 320px, and names a screen reader cannot tell apart (three identical "Add to cart" buttons, alt text that repeats the heading beside it, an aria-label that drops the visible words).

Everything runs on your machine in a headless browser. It works on `localhost`, staging URLs, public sites and plain `.html` files. Nothing is sent to AccessLumens and no account or API key is needed.

[Watch the 1-minute demo](https://youtu.be/kS0NEJZz0MU): Claude Code takes a page from 75 to 100, then axe DevTools confirms zero issues. Setup guide and FAQ: [accesslumens.com/mcp](https://accesslumens.com/mcp?utm_source=github&utm_medium=readme).

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

Ready-made instructions that tell your agent not just what is wrong but how to fix it well: in the source, native HTML before ARIA, shared causes fixed once, design and behaviour unchanged, and every fix verified by a rescan. In clients that support MCP prompts they appear as slash commands: in Claude Code, type `/` and pick `accesslumens:fix-all`. Each takes an optional `url`; leave it empty and the agent finds your dev server. Some clients, including some VS Code Copilot versions, do not list MCP prompts; there, just ask your agent to fix the accessibility issues on your page. The scanner's results carry the same guidance.

| Prompt | What it does |
| --- | --- |
| `fix-page` | Scans one page, fixes every issue in the source, rescans until no Critical or Serious issues remain, and lists what it changed. |
| `fix-all` | Two passes over every route in your app: fixes everything the scanner finds, then reviews the code for what scanners cannot detect (duplicate button names, focus in dialogs, route-change announcements, form errors, reduced motion). Rescans every route and reports scores before and after. |
| `audit` | The same review without changing any files: issues grouped by root cause, with the file each one comes from and an ordered fix plan. |

## Tools

| Tool | What it does |
| --- | --- |
| `check_accessibility` | Scans a URL, localhost address or local `.html` file. Returns a 0-100 score and each issue with its severity, WCAG success criteria and how to fix it, and every failing element's selector, markup and failure reason (`explain_issue` adds who it affects). Options: `keyboard` (default on), `crawl` (follow links, up to 10 pages), `max_issues` (default 30). |
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
- The very first start downloads the package and can take over 30 seconds, which some clients (Claude Code among them) treat as a failed connection. If the server shows as failed or stuck connecting the first time, reconnect it once (`/mcp` in Claude Code); later starts take a few seconds.
- Set `ACCESSLUMENS_DEBUG=1` to log scanner detail to stderr.

## Full reports and PDFs

For a shareable report with your legal context (ADA, EAA, Section 508), multi-page journeys through signed-in flows, and PDF accessibility checks and repair, see [accesslumens.com](https://accesslumens.com/?utm_source=github&utm_medium=readme).

## License

Free to use, including commercially. Redistribution and resale are not permitted. See [LICENSE](LICENSE).

## About this repository

The server ships as the npm package [`@accesslumens/mcp`](https://www.npmjs.com/package/@accesslumens/mcp). This repository holds its directory listing (`server.json`, `glama.json`) and the Dockerfile, and is the place for questions, bug reports and feature requests: [open an issue](../../issues) or write to support@accesslumens.com.
