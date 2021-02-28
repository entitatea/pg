#!/bin/bash

echo '[pgdg82]
name=PostgreSQL 8.2 RPMs for RHEL/CentOS 5
baseurl=https://yum-archive.postgresql.org/8.2/redhat/rhel-5-x86_64
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG' | tee /etc/yum.repos.d/postgres82.repo

yum install -y http://vault.centos.org/centos/6/os/x86_64/Packages/compat-libtermcap-2.0.8-49.el6.x86_64.rpm
yum install -y http://vault.centos.org/centos/6/os/x86_64/Packages/openssl098e-0.9.8e-20.el6.centos.1.x86_64.rpm
yum install -y http://vault.centos.org/centos/6/os/x86_64/Packages/compat-readline5-5.2-17.1.el6.x86_64.rpm
yum -y install postgresql-libs-8.2.23-1PGDG.rhel5
yum -y install postgresql-server-8.2.23-1PGDG.rhel5
sed -i -e 's/.\${PGPORT}//g' /etc/init.d/postgresql
service postgresql initdb
sed -i -e "s|#listen_addresses = 'localhost'|listen_addresses = '*'|g" \
-e 's|max_connections = 100|max_connections = 1024|g' \
-e 's|shared_buffers = 32MB|shared_buffers = 256MB|g' \
-e 's|#work_mem = 1MB|work_mem = 16MB|g' \
-e 's|#maintenance_work_mem = 16MB|maintenance_work_mem = 256MB|g' \
-e 's|#max_stack_depth = 2MB|max_stack_depth = 4MB|g' \
-e 's|max_fsm_pages = 204800|max_fsm_pages = 1048576|g' \
-e 's|#max_fsm_relations = 1000|max_fsm_relations = 32768|g' \
/var/lib/pgsql/data/postgresql.conf
