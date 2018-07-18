# Build images

## Coog backend image

First of all, you will have to install sphinx and all sphinx dependencies using
pip. These dependencies are available in *coog-dep* file. This file is
available in any *Coog* repository (or you can check **github**). This is not
mandatory as these dependencies should already be installed, but it is advised
to at least check they are installed to avoid bad surprises.

Install **rst2pdf** via **pip** (if requirement isn't already satisfied)

``` bash
pip install rst2pdf
```

The default configuration for building a **Coog** image contains **coog**,
**trytond**, **trytond-modules**, **sao**, **coog-bench** and **proteus**
repositories. It is the default build configuration defined in the
*coog-admin/images/coog/repos.vendor* file.

If you want to include additional
repositories to the image you want to build, for instance **customers**, you
will have to create a new file named **repos.custom** in
*coog-admin/images/coog* and add a line following the same pattern as is
**repos.vendor**.

For instance, to add **customers**, open the newly created
*coog-admin/images/coog/repos.custom* and add the following line

``` bash
customers;git@github.com:coopengo/customers
```

Then, to build a **Coog** image, run the following command

``` bash
./coog build \
    coopengo/coog-<customer>:<version_number> \    # Coog image name
    coog:coog-<version_number>\                    # Coog repository
    trytond-modules:coog-<version_number> \        # Trytond native modules
    trytond:coog-<version_number> \                # Tryton framework engine
    sao:coog-<version_number> \                    # Backoffice web client
    coog-bench:coog-<version_number> \             # Bench utility
    customers:coog-<version_number>                # Customers specific repository
```

If you want the image built in **python3**, add *VARIANT=3* before the build
command, otherwide the image will be built in **python2**

Optional variables for *build* commands:

* DB_NAME: name of the database to use
* LOG_LEVEL: Log verbosity level

## Coog web image
To build a **Web** image, follow the same logic, this time *coog-api* and 
*coog-app* repositories are used

``` bash
./web build \
    coopeng/web:<version_number> \        # Web image name
    coog-api:coog-<version_number> \      # API repository 
    coog-app:coog-<version_number> \      # APP repository
```

**Web** image has two components

* **API**: a REST webservice based on **Coog**'s RPC. It listens on port 3000
  (in **Docker** network) and is like an **nginx** client for backend calls.
* **APP**: an SPA API client

Optional variables for *build* commands:

* DB_NAME: name of the database to use
* LOG_LEVEL: Log verbosity level


## Unoconv image
In order for documents generation to work properly, build **unoconv** by running

``` bash
./unoconv build coopengo/unoconv:latest
```