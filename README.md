# paper-box
Aabernathy Paper docker containers and tools.

# Getting Started
After cloning this repository run the following commands for final
setup:
```bash
git submodule init paper-box-configs
tools/helpers.sh build latest && tools/helpers.sh init
```

# Helpers Tool
For quick and easy management of Aabernathy Paper's ecosystem use the
`tools/helpers.sh` tool. The helpers tool has a number of directives
for frequent use commands.

### Helpers Commands
- **build** [tag_name...] | Creates the local images used for running
  PaperMC services.
- **clean** | Remove containers and services sub-directory.
- **init** | Starts initiates Aabernathy Paper's services. Including
  loading of their configs, plugins and assets.
- **start** | shortcut to 'docker compose start'.
- **stop** | shortcut to 'docker compose stop'.
- **update_all** | Updates service directory configs, plugins and
  assets and restarts all services.
- **update** [name] [id...] | Updates service directory configs,
  plugins and assets then restarts target services.
- **sync_config** [name] [id...] | rsync shortcut to update configs,
  plugins and assets.
