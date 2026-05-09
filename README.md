# jan-cli

A thin wrapper that exposes [chevp/chi](https://github.com/chevp/chi) under
the command name `jan`. No source duplication — chi is pulled in as a normal
npm dependency (git URL, no npm registry required), and `bin/jan` just
delegates to `chi/dist/index.js`.

> Same UX, same config, same workflows as `chi` — just typed as `jan`.

## Install

Requires Node.js 20+. Works the same on macOS, Linux, and Windows.

### Via npm (recommended)

```sh
npm install -g github:chevp/jan-cli
```

This fetches jan-cli + chi, builds chi via its `prepare` hook, and wires
`jan` (and `jan.cmd` on Windows) into npm's global bin directory.

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
git clone https://github.com/chevp/jan-cli.git
cd jan-cli
./install.sh        # macOS / Linux / WSL
```

On Windows (PowerShell):

```powershell
git clone https://github.com/chevp/jan-cli.git
cd jan-cli
.\install.ps1
```

## Update

Once installed, jan can update itself — works for both global and from-source installs:

```sh
jan update
```

This detects the install layout and either runs `npm install -g github:chevp/jan-cli` (global) or `git pull --ff-only && npm install` (workspace clone), pulling the latest chi as a dependency in either case.

## What this is

```
jan-cli/
├── bin/
│   ├── jan              # node shim → require.resolve("chi/dist/index.js")
│   └── jan.cmd          # Windows shim
├── install.sh
├── install.ps1
└── package.json         # depends on  "chi": "github:chevp/chi"
```

`jan <args>` is functionally identical to `chi <args>`. All chi config
(`~/.chi/config`, `CHI_*` env vars, `.che/workflows/*.yml` discovery) applies
unchanged.

## Why a wrapper?

So the source lives in exactly one place. If `chi` adds a new command,
`jan` gets it on the next `npm install -g github:chevp/jan-cli` (which
re-fetches chi's latest `main`). No duplicated source tree to maintain.

## License

MIT — see chi for full attribution; this repo is just a wrapper.
