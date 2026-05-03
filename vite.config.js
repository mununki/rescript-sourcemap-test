import { Buffer } from "node:buffer";
import { readFile } from "node:fs/promises";

import { defineConfig } from "vite";

function rescriptInputSourceMaps() {
  return {
    name: "rescript-input-source-maps",
    enforce: "pre",
    async load(id) {
      if (!id.endsWith(".js") || !id.includes("/src/")) {
        return null;
      }

      try {
        const code = await readFile(id, "utf8");
        let map;
        try {
          map = JSON.parse(await readFile(`${id}.map`, "utf8"));
        } catch {
          const inlineMap = code.match(
            /\/\/# sourceMappingURL=data:application\/json;base64,([A-Za-z0-9+/=]+)\s*$/,
          );
          if (inlineMap == null) {
            return null;
          }
          map = JSON.parse(Buffer.from(inlineMap[1], "base64").toString("utf8"));
        }
        if (process.env.DEBUG_RESCRIPT_MAPS === "1") {
          console.log(`[rescript-input-source-maps] ${id}`);
        }
        return { code, map };
      } catch {
        return null;
      }
    }
  };
}

export default defineConfig({
  plugins: [rescriptInputSourceMaps()],
  server: {
    port: 5173,
    strictPort: false
  },
  build: {
    sourcemap: true
  }
});
