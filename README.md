# jan-cli

A thin wrapper that exposes [chevp/chi](https://github.com/chevp/chi) under the command name `jan`. No source duplication — chi is pulled in as a normal npm dependency (git URL, no npm registry required), and `bin/jan` just delegates to `chi/dist/index.js`.

> Same UX, same config, same workflows as `chi` — just typed as `jan`. The LLM backend is hardwired to the **cura** Cloud Run endpoint.

## Install

Requires Node.js 20+. Works the same on macOS, Linux, and Windows.

### Via npm (recommended)

```sh
npm install -g github:chevp/jan-cli
```

This fetches jan-cli + chi (chi ships its prebuilt `dist/` in the github tarball) and wires `jan` (and `jan.cmd` on Windows) into npm's global bin directory.

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

## First-time setup

Run **once** after install to enter your cura credentials:

```sh
jan init
```

`jan init` prompts for `BASIC_AUTH_USER` and `BASIC_AUTH_PASSWORD` (password input is masked), saves them to `~/.chi/config` (chmod 600), pings the cura endpoint, and confirms the model is available. Re-run with `--force` to update saved credentials.

If you'd rather not be prompted, set both env vars before running `jan init`:

```sh
export BASIC_AUTH_USER=<user>
export BASIC_AUTH_PASSWORD=<password>
jan init
```

## Update

Once installed, jan can update itself — works for both global and from-source installs:

```sh
jan update
```

This detects the install layout and either runs `npm install -g github:chevp/jan-cli` (global) or `git pull --ff-only && npm install` (workspace clone), pulling the latest chi as a dependency in either case.

## Usage

`jan <args>` is functionally identical to `chi <args>`. Most-used commands:

```sh
jan status                              # repo state + cura reachability
jan commit                              # stage all + AI-generated commit message
jan commit --push                       # also push
jan flow my-feature                     # cut a flow branch
jan ship                                # add + commit + push (recursive)
jan done                                # squash-merge the active flow PR

jan issue                               # AI-drafted new issue (interactive)
jan issue list --limit 20
jan issue close 42

jan explain                             # diagnose last failed jan ship/commit
jan explain "why is git push hanging?"  # ad-hoc question

jan doctor                              # all checks (git, cura, workflow)
jan doctor cura                         # only the cura endpoint check

jan config                              # list saved settings
jan config llm_model smollm2:135m       # change a key
jan config edit                         # open ~/.chi/config in $EDITOR
```

`jan issue fix <n>` is **not available** — it required an interactive Claude CLI session that no longer exists in cura-only mode.

For workflows / worktrees, `jan workflow list`, `jan run <name>`, `jan work <name>`, `jan work list|rm|cd` work the same as the chi equivalents.

## Configuration

`jan` shares chi's config (`~/.chi/config`). Env vars always win over the file.

| Key (`~/.chi/config`)  | Env var               | Default                                              |
|------------------------|-----------------------|------------------------------------------------------|
| `basic_auth_user`      | `BASIC_AUTH_USER`     | **required**                                         |
| `basic_auth_password`  | `BASIC_AUTH_PASSWORD` | **required**                                         |
| `llm_url`              | `CHI_LLM_URL`         | `https://cura-llm-3j2fyuwcdq-oa.a.run.app`           |
| `llm_model`            | `CHI_LLM_MODEL`       | `smollm2:135m`                                       |
| `max_diff_chars`       | `CHI_MAX_DIFF_CHARS`  | `8000`                                               |

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

## Why a wrapper?

So the source lives in exactly one place. If `chi` adds a new command, `jan` gets it on the next `npm install -g github:chevp/jan-cli` (which re-fetches chi's latest `main`). No duplicated source tree to maintain.

## License

MIT — see chi for full attribution; this repo is just a wrapper.
