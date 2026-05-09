# jan-cli

A thin wrapper that exposes [chevp/chi](https://github.com/chevp/chi) under
the command name `jan`. No source duplication — chi is pulled in as a git
submodule and built locally; `bin/jan` just delegates to `chi/dist/index.js`.

> Same UX, same config, same workflows as `chi` — just typed as `jan`.

## Install

Requires Node.js 20+ and `git` (for the submodule fetch). Works the same on
macOS, Linux, and Windows.

### Via npm (recommended)

```sh
npm install -g github:chevp/jan-cli
```

This clones the repo with its `chi` submodule, runs the `prepare` hook to
build chi, and wires `jan` (and `jan.cmd` on Windows) into npm's global
bin directory.

To **update** to the latest `main` of both jan-cli and chi, run the same
command again:

```sh
npm install -g github:chevp/jan-cli
```

To remove:

```sh
npm uninstall -g jan-cli
```

Pin to a specific commit/tag of jan-cli:

```sh
npm install -g github:chevp/jan-cli#<sha-or-tag>
```

### From source (clone + script)

```sh
git clone --recurse-submodules https://github.com/chevp/jan-cli.git
cd jan-cli
./install.sh        # macOS / Linux / WSL
```

On Windows (PowerShell):

```powershell
git clone --recurse-submodules https://github.com/chevp/jan-cli.git
cd jan-cli
.\install.ps1
```

If you forgot `--recurse-submodules` on the clone, run
`git submodule update --init --recursive` once before installing.

To **update** a from-source install:

```sh
git pull
git submodule update --remote --merge   # bump chi to latest main
npm install                              # rebuilds chi via the prepare hook
```

## What this is

```
jan-cli/
├── bin/
│   ├── jan              # node shim → ../chi/dist/index.js
│   └── jan.cmd          # Windows shim
├── chi/                 # ← git submodule pointing at chevp/chi
├── scripts/
│   └── prepare.js       # builds chi after npm install
├── install.sh
├── install.ps1
└── package.json
```

`jan <args>` is functionally identical to `chi <args>`. All chi config
(`~/.chi/config`, `CHI_*` env vars, `.che/workflows/*.yml` discovery) applies
unchanged.

## Why a wrapper?

So the source lives in exactly one place. If `chi` adds a new command,
`jan` gets it on the next `npm install -g github:chevp/jan-cli` (which
re-fetches the submodule pointer's latest commit on `main`). No duplicated
source tree to maintain.

## Bumping the chi pin

Inside a clone of jan-cli:

```sh
git submodule update --remote --merge chi   # fetch chi's latest main
git add chi
git commit -m "bump chi pin"
git push
```

## License

MIT — see chi for full attribution; this repo is just a wrapper.
