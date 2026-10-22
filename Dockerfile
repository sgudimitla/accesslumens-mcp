# AccessLumens MCP server (stdio). Installs the published npm package on Playwright's image, which
# already carries Chromium and its system libraries, so the first scan does not download a browser.
# Keep the image tag on the same Playwright version the package depends on.
FROM mcr.microsoft.com/playwright:v1.60.0-noble

ARG ACCESSLUMENS_MCP_VERSION=0.1.2

WORKDIR /app
RUN npm init -y >/dev/null \
 && npm install --omit=dev --no-audit --no-fund "@accesslumens/mcp@${ACCESSLUMENS_MCP_VERSION}" playwright@1.60.0 \
 && npm cache clean --force

USER pwuser
ENTRYPOINT ["node", "/app/node_modules/@accesslumens/mcp/dist/index.js"]
