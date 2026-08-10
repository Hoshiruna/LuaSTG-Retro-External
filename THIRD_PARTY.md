# Third-party dependencies

The manager uses the following upstream sources. A packaged binary must retain
the license files installed from those sources where applicable.

| Component | Revision | License/source |
| --- | --- | --- |
| CPM.cmake | 0.43.1 | [MIT](https://github.com/cpm-cmake/CPM.cmake/blob/v0.43.1/LICENSE) |
| beautiful-win32-api | `b734d3bb5b05ca4c3859bb174b131139fc72bd4d` | [MIT](https://github.com/Demonese/beautiful-win32-api/blob/b734d3bb5b05ca4c3859bb174b131139fc72bd4d/LICENSE) |
| Discord RPC | `963aa9f3e5ce81a4682c6ca3d136cddda614db33` | [MIT](https://github.com/Hoshiruna/discord-rpc/blob/963aa9f3e5ce81a4682c6ca3d136cddda614db33/LICENSE) |
| QOI | `97bacc86a9c4abf5a2d452102dc26546c4c670b9` | [MIT](https://github.com/phoboslab/qoi/blob/97bacc86a9c4abf5a2d452102dc26546c4c670b9/LICENSE) |
| Lua CJSON | `5ce46a80b10ef9d380a45c9e6cff9ecffbe71ebb` | [MIT](https://github.com/openresty/lua-cjson/blob/5ce46a80b10ef9d380a45c9e6cff9ecffbe71ebb/LICENSE) |
| LuaJIT | `fff48de34357e8e86197a45f5b4bc2b1b28cce53` | [MIT and bundled notices](https://github.com/Legacy-LuaSTG-Engine/LuaSTG-Sub-LuaJIT/blob/fff48de34357e8e86197a45f5b4bc2b1b28cce53/COPYRIGHT) |
| LuaSQL | 2.8.1 | [Upstream project](https://github.com/lunarmodules/luasql/tree/2.8.1) |
| SQLite amalgamation | copied with LuaSTG Retro | [Public domain](https://www.sqlite.org/copyright.html) |
| Tracy | 0.14.0 | [BSD-3-Clause](https://github.com/wolfpld/tracy/blob/v0.14.0/LICENSE) |
| xmath | `7f594caeaff8d14c8032bb246c5d435e0d40c65d` | [MIT](https://github.com/Legacy-LuaSTG-Engine/lstgx_Math/blob/7f594caeaff8d14c8032bb246c5d435e0d40c65d/LICENSE) |

The local patches, Lua bindings, and lightweight support libraries copied from
[LuaSTG Retro](https://github.com/Hoshiruna/LuaSTG-Retro) are distributed under
that project's MIT license.

The Steamworks SDK is not downloaded or redistributed by this project. Its
use is governed by Valve's Steamworks SDK agreement.

whose root and `cmake/` files are MIT-licensed.
