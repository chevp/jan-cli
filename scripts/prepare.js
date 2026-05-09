#!/usr/bin/env node
import { existsSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const chiDir = join(root, "chi");
const chiPkg = join(chiDir, "package.json");

if (!existsSync(chiPkg)) {
  console.warn("jan-cli: chi/ submodule not initialized — skipping build.");
  console.warn("        run 'git submodule update --init --recursive' to populate it,");
  console.warn("        then 'npm install' again (or use install.sh / install.ps1).");
  process.exit(0);
}

if (process.env.JAN_SKIP_PREPARE === "1") {
  console.log("jan-cli: JAN_SKIP_PREPARE=1 set, skipping chi build");
  process.exit(0);
}

const npm = process.platform === "win32" ? "npm.cmd" : "npm";

console.log("jan-cli: installing chi deps + building dist");
const install = spawnSync(npm, ["install", "--no-audit", "--no-fund"], {
  cwd: chiDir,
  stdio: "inherit",
  shell: process.platform === "win32",
});
if (install.status !== 0) {
  console.error("jan-cli: chi 'npm install' failed");
  process.exit(install.status ?? 1);
}

const build = spawnSync(npm, ["run", "build"], {
  cwd: chiDir,
  stdio: "inherit",
  shell: process.platform === "win32",
});
if (build.status !== 0) {
  console.error("jan-cli: chi 'npm run build' failed");
  process.exit(build.status ?? 1);
}

console.log("jan-cli: chi built → bin/jan is ready");
