import { spawnSync } from "node:child_process";
import { resolve } from "node:path";

const projectRoot = resolve(import.meta.dirname, "..");

const build = spawnSync("pnpm", ["exec", "rescript", "build"], {
  cwd: projectRoot,
  encoding: "utf8",
  stdio: "pipe",
});

if (build.status !== 0) {
  process.stdout.write(build.stdout);
  process.stderr.write(build.stderr);
  process.exit(build.status ?? 1);
}

const run = spawnSync(
  process.execPath,
  ["--enable-source-maps", "src/NodeProbe.js"],
  {
    cwd: projectRoot,
    encoding: "utf8",
    stdio: "pipe",
  },
);

const output = `${run.stdout}${run.stderr}`;

if (run.status === 0) {
  console.error("Expected src/NodeProbe.js to throw, but it exited successfully.");
  process.exit(1);
}

const stackLine = output
  .split("\n")
  .find(line => /at .*NodeProbe\.res:\d+:\d+/.test(line));

if (!stackLine) {
  console.error("Expected Node stack trace to mention NodeProbe.res.");
  console.error(output);
  process.exit(1);
}

console.log("Node sourcemap stack trace resolved to ReScript:");
console.log(stackLine.trim());
