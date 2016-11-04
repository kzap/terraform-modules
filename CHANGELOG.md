
0.2.3 / 2016-11-04
==================

  * - rename centos7 dir to centos-7

0.2.2 / 2016-11-04
==================

  * - moving openstack provider for a server into app-server/ directory
  * - moving provisioning files into app-db-server/ directory for a LAMP stack, so we can host multiple types of provisioning scripts

0.2.1 / 2016-11-03
==================

  * - make openstack example actually use github source

0.2 / 2016-11-03
================

  * fix indent
  * updating readme
  * changing network detection function in bash provisioner to make it use more checks if some programs are not available
  * - make provisioner work using key_file_path and ${file()} - move provisioner into bash/centos7 so its specific to the os
  * - reorganizing module into examples/ providers/ and provisioners/
  * - making output a list - making module use ${path.root} for the provisioning scripts
  * - adding output to example - converting openstack output of nodes_floating_ips to a list
  * - adding openstack specific example with openstack_variables.tf and openstack_example.tf files - global_variables.tf is for variables used across all setups
  * - adding example files for usage of module
  * - moved provisioning scripts to base dir so it can be shared between providers
  * fix output, remove escaped double quote

0.1.7 / 2016-10-08
==================

  * - make apache conf files link instead of copy

0.1.6 / 2016-05-17
==================

  * update my.cnf to mariadb my.cnf

0.1.5 / 2016-05-16
==================

  * update readme, make db init generic, remove dreamcompute override

0.1.4 / 2016-05-16
==================

  * making default httpd user: apache

0.1.3 / 2016-05-16
==================

  * adding image_id and flavor_id variables instead of lookup
  * update readme
  * updating README and adding Apache LICENSE

0.1.1 / 2016-05-01
==================

  * updating README and adding Apache LICENSE

0.1 / 2016-05-01
================

  * update changelog
  * initial commit for LAMP terraform with provisioning
  * Initial commit
