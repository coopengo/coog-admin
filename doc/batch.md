# Managing batch treatment with coog-admin

The *batch* command allows executing a coog batch. A celery batch worker
must be launched in order for it to work properly. Its execution follows
the ordered steps:

-   Jobs generation
-   Batch execution
-   *Optional*: Failed batches split and wait for new jobs génération
-   Return with exit status *OK* if all jobs succeed

The execution of a chain and of the daily chain follow the same routine.
These commands are usually launched by **cron** and their outputs are
usually configured to be sent by mail.

This is an example of how to launch *Coog*'s *ir.ui.view.validate*
batch:

``` bash
./coog celery 1
./coog batch ir.ui.view.validate --job_size=10
./coog redis celery qlist ir.ui.view.validate
./coog batch ir.ui.vuew.validate --job_size=100 --crash=144
./coog redis celery q ir.ui.view.validate 
```

Here are some useful celery commands

-   For all queues:

``` bash
./coog redis celery list
./coog redis celery flist 
```

-   For one queue:

``` bash
./coog redis celery fail ir.ui.view.validate
./coog redis celery q ir.ui.view.validate 
./coog redis celery qlist ir.ui.view.validate 
./coog redis celery qcount ir.ui.view.validate 
./coog redis celery qtime ir.ui.view.validate 
./coog redis celery qarchive ir.ui.view.validate 
./coog redis celery qremove ir.ui.view.validate 
```

-   For one job:

``` bash
./coog redis celery j
./coog redis celery jarchive
./coog redis celery jremove
```

**cron** configuration allows handling jobs execution generation and
monitoring, and notifying batch chain execution end by email