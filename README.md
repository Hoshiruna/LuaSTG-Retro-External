# LuaSTG Retro External

This repository builds and packages the external libraries used by LuaSTG
Retro independently from the engine. 

## Dependency groups

- `all` builds every managed dependency.
- `core` builds beautiful-win32-api, xmath, QOI, Discord RPC, and Tracy.
- `lua` builds LuaJIT, Lua filesystem, Lua CJSON, LuaSQL/SQLite, and the Steam
  binding.

The Steam binding builds its SDK-free stub by default. Set
`LUASTG_STEAM_API_ENABLE=ON` only after placing a licensed Steamworks SDK under
`steam_api/SteamworksSDK/sdk`.

## Source management

When a complete dependency source tree already exists in this repository, it
is used directly. Missing or empty copied source directories are populated in
the build tree through CPM.cmake at the exact revisions listed in
[THIRD_PARTY.md](THIRD_PARTY.md). Set `LSTGEXT_USE_LOCAL_SOURCES=OFF` to always
use the pinned remote revisions.

## Local packaging

Configure one of the supplied Visual Studio 2022 presets, then build its
release package preset:

```powershell
cmake --preset vs2022-amd64
cmake --build --preset windows-amd64-release
```

The `zip-install` target builds `external-build`, installs the libraries,
headers, and notices, and creates
`build/<arch>/luastg-retro-external-<arch>-release.zip`.

The GitHub Actions workflow provides the same process for x86 and AMD64
artifacts. It can package `all`, `core`, or `lua` from a manual run. An ARM64
preset is supplied for native ARM64 development machines; it is intentionally
not run on GitHub's x64 Windows host because LuaJIT's build-time generators
must execute on the host.
