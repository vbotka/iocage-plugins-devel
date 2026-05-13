# iocage plugins devel

* [Create an unofficial iocage plugin](https://www.truenas.com/community/resources/create-an-unofficial-iocage-plugin.99/)
* [iocage plugins](https://freebsd.github.io/iocage/plugins.html)


## ansible-pull iocage plugins

### ansible-pull-syslogng-client
Install and configure syslog-ng client.
- Install: ansible, git, sudo, syslog-ng
- Run: post_install.sh
- Repo: https://github.com/vbotka/ansible-conf-syslogng-client.git
- Example: https://ansible-collection-freebsd.readthedocs.io/en/latest/examples/521/example.html

### ansible-pull-syslogng-server
Install and configure syslog-ng server.
- Install: ansible, git, lnav, sudo, syslog-ng
- Run: post_install.sh
- Repo: https://github.com/vbotka/ansible-conf-syslogng-server.git
- Example: https://ansible-collection-freebsd.readthedocs.io/en/latest/examples/521/example.html

### ansible-syslogng
Install and configure syslog-ng server.
- Install: ansible, git, sudo, syslog-ng
- Run: post_install.sh
- Repo: https://github.com/vbotka/ansible-conf-syslogng-server.git
- Example: https://ansible-collection-freebsd.readthedocs.io/en/latest/examples/520/example.html

### ansible-pull-test
Test ansible-pull
- Install: ansible, git, sudo
- Run: post_install.sh

## other iocage plugins

### ansible-test
Test ansible.
- Install: python3, sudo
- Run: post_install.sh

### ansible-zero
Test minimal ansible.
- Install: python3, sudo
- Run: post_install.sh
