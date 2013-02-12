Web Experience Toolkit (Drupal)
===============================

**Ariadne cookbook**

This cookbook is intended to perform the "last mile" of configuration
needed to bring the Ariadne environment to a fully provisioned state for
development of this install profile:

  * https://github.com/wet-boew/wet-boew-drupal

Quick Setup
-----------

If you already have an Ariadne environment configured and set up on your
system, you may run the following commands to install this project
cookbook and boot Ariadne:

    cd path/to/ariadne
    rake "init_project[https://github.com/wet-boew/ariadne-wet-boew-drupal]"
    project=wet-boew-drupal branch=master vagrant up

When the Chef run has completed, your local site with have a
username/password pair of `admin`/`S4mpleP^ssword`, and will be
available at:

    http://wet-boew-drupal.dev

Full instructions for project setup are available in the [Ariadne's
official README][ariadne-project-setup].

Features
--------

  - This project makes use of the `clean=true` environment variable. To
    wipe the data and rebuild the site, simply run `clean=true vagrant
    provision`. (Requires at least Ariadne v1.1.0)
  - This project also makes use of the `branch` CLI argument, so a
    specific branch can be built over an existing site with `clean=true
    branch=123-new-feature vagrant provision`. (Requires at least
    Ariadne v1.2.0)

<!-- Links -->
   [ariadne-project-setup]: https://github.com/myplanetdigital/ariadne#ariadne-project
