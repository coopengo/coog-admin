# COOG ADMIN

Coog Admin is a toolkit that makes it easy to manage Coog (Insurance ERP from
[Coopengo](http://www.coopengo.com)). It is aimed to provide all useful
commands to:

- Deploy Coog (in all recommended configurations)
- Administrate Coog (monitor in runtime, upgrade, maintenance procedure, etc)
- Help on Coog troubleshooting (shared knowledge base between all Coog
  installations)

Coog Admin should be installed (cloned) on Coog host server. All other resources
are provides via Docker images.

[Docker](https://www.docker.com/) is the recommended platform to deploy Coog:

- Makes it easy to communicate with system administrators
- Designed to support all kind of Operating Systems
- Helpful to get integrated with third party softwares (right now we use
  postgresql, redis, nginx, sentry, etc)

Coog Admin is a passive tool. It does not launch any agent on your server. All
provided deployment scripts are just docker calls wrappings.

## What is this tool

- Set of shell scripts to ensure operations
- All Coog data are stored in **one folder** named `$COOG_DATA_DIR`
    - This ensures that the host server is kept clean (no files at different
    locations).
- Coog data includes postgresql databases, redis persistency, coog documents.
  All those are stored in sub-fodlers of `$COOG_DATA_DIR`.
- All operations scripts source a special script (`config`) that sets the
  configuration
- `config` last line is:

  ```
  [ -f $COOG_DATA_DIR/config ] && source $COOG_DATA_DIR/config
  ```
  Basically, all the configuration is done through environment variables, which
  are defined in `config`. To modify the configuration, just set your updated
  environment variables in `$COOG_DATA_DIR/config`.
- To clean your environment, you can just remove `$COOG_DATA_DIR` folder

It is very recommended to read the scripts to have a deep understanding of how
it works:

- [config](https://github.com/coopengo/coog-admin/blob/master/config):
  configuration items explained
- [postgres](https://github.com/coopengo/coog-admin/blob/master/postgres):
  typical launcher


## Documentation

- [Deploy a coog environnment with coog-admin](doc/coog_deployment_with_coog_admin.md)
- [Apply a patch or upgrade Coog with coog-admin](doc/upgrade_coog_env.md)
- [Backup a coog environnement](doc/backup_coog_env.md)
- [Command](doc/command.md)
- [Build images](doc/build_images.md)
- [Managing batch treatment with coog-admin](doc/batch.md)
- [More on NGINX configuration](doc/nginx_conf.md)
- [How to manage file sharing with docker volumes](doc/manage_volumes.rst)
- [Setup OAuth](doc/oauth_setup.md)
