# nixploit

**Nixploit** — a modular Nix flake that provides a focused CTF / pentesting environment.  
Designed to be **imported as a flake input** into your Home Manager flake (or used standalone via `nix develop`) so tooling stays compartmentalized.

Author / Maintainer: **MelkerI03**  
License: **BSD 3-Clause**

> ⚠️ **Note:** this flake contains **unfree packages**. Make sure your Nixpkgs configuration allows unfree software (`config.allowUnfree = true`) when consuming this flake.

---

## What it is

Nixploit exports user-facing artifacts intended for pentesting and CTF workflows:

- `homeManagerModules.nixploit` — a Home Manager module that installs and configures user-level CTF tooling.
- (Planned) `devShells.nixploit` — a reproducible developer shell with the primary toolset for ephemeral sessions.
- (Planned) `nixosModules.nixploit` — optional system-level exports in future releases (opt-in).

This flake intentionally **does not** modify system-level configuration by default — it focuses on user-level tooling and dev environments.

---

## Quick start

### 1) Try it standalone (ephemeral devshell)

From a clone of this repo:
```bash
git clone https://github.com/MelkerI03/nixploit.git
cd nixploit
nix develop
# You're now inside the nixploit devshell
```

Or directly from GitHub:
```bash
nix develop github:MelkerI03/nixploit
```

### 2) Use it as a flake input (recommended integration)

The flake is intended to be consumed by your own Home Manager/Nix flake. Add it as an input and reference the exported module/devShell in your flake outputs.

Example (generic snippet — adapt to your flake):

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager.url = "github:nix-community/home-manager";
  nixploit.url = "github:MelkerI03/nixploit";
};

outputs = inputs: {
  # In your home-manager configuration's modules list, reference:
  # inputs.nixploit.homeManagerModules.nixploit
};
```

> Keep your flake structure as you prefer; this repo **does not** assume any particular layout of the consumer flake.

### 3) Override local copy (no flake.lock changes)

If you maintain a local copy of nixploit and want to test it without editing your `flake.lock`:

```bash
home-manager switch --flake .#<your-user-attr> --override-input nixploit path:<path-to-nixploit>
```

Replace `.#<your-user-attr>` with the appropriate flake reference for your setup.

---

## Supported platforms

- **x86_64-linux** — primary supported platform  
- **aarch64-linux** — supported where package availability permits

The flake attempts to be portable; packages unavailable on a given platform are omitted. Consumers should target at least `x86_64-linux` for full functionality.

---

## Features & scope

- Curated set of pentesting / CTF tools (reverse engineering, binary exploitation, network enumeration, forensics, web tools, and utilities).  
- (Planned) Exports both persistent (Home Manager module) and ephemeral (devShell) consumption models.  
- Keeps CTF tooling isolated from a user's base configuration; easy to enable/disable.  

> The exact package list is maintained in the flake source. See `flake.nix` / module files for the current items.

---

## `fhs` helper (run "regular" binaries)

This flake installs a small helper command called `fhs` that creates an **FHS-style runtime filesystem** so you can run non‑Nix / “regular” binaries that expect a traditional Linux filesystem layout.

### What it does
- Sets up an FHS-like view (standard `/bin`, `/lib`, `/usr`, etc.) and binds necessary runtime directories so binaries not packaged for Nix can execute in a predictable environment.
- Intended for convenience when using tools from challenge bundles, vendor binaries, or other non-Nix-provided executables inside the nixploit devshell or your user session.

### Basic usage
Run a command inside the FHS environment:
```bash
# run a single command inside the FHS environment
fhs <command> [args...]

# drop into an interactive shell inside the FHS environment
fhs
# then run binaries normally, e.g.
# $ ./some-binary
# $ /usr/bin/strings some-binary
```

Examples:
```bash
# open a shell and run a vendor binary
fhs ./some-proprietary-tool

# run a single program directly
fhs /usr/bin/strings /path/to/binary
```

### Notes & security
- `fhs` is a convenience wrapper — it creates an FHS-like environment but is **not** a full sandbox. Do **not** run untrusted binaries without additional isolation (containers, VMs, or sandboxing tools).
- On some systems the helper may rely on user namespaces or kernel features. If `fhs` fails to start, check kernel/user-namespace support or run it inside a privileged container/VM.
- The helper is primarily intended to ease running challenge/vendor binaries that are difficult to repackage for Nix. Use it selectively and with caution.

If you want a stricter sandboxed environment for untrusted binaries, consider running them inside a disposable VM, container, or using namespace/isolation tools in addition to `fhs`.

---

## Security & ethics

- Intended for legitimate security research, CTFs, education, and authorized pentesting only.  
- Do **not** use these tools against systems for which you do not have explicit permission.  
- The author takes no responsibility for misuse.

---

## Contributing

Contributions welcome. Suggested workflow:

1. Fork the repo and create a branch.  
2. Add or update module/package lists. Include supported platforms and any runtime dependencies.  
3. Test locally with `nix develop`.  
4. Open a pull request with a clear description and rationale.

When adding complex tools, prefer platform guards (so the flake remains portable) and document any `allowUnfree` or external runtime requirements (e.g., JVM).

---

## Roadmap (non-exhaustive)

- Mirror `homeManagerModules` with matching `devShells` for easier ephemeral use.  
- Add optional `nixosModules.nixploit` for users who don't use home-manager.
- Add basic smoke tests for main architectures.

---

## License

BSD 3-Clause License. See the `LICENSE` file.

---

## Contact

Open issues or PRs on the repository for bugs and feature requests. For urgent matters, use the repo issue tracker.
