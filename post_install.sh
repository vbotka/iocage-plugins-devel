#!/bin/sh

plugin_name=$(hostname)
ansible_custom_facts_dir="/etc/ansible/facts.d"

case "$plugin_name" in
    ansible-syslogng)
	# Create custom facts
	mkdir -p "$ansible_custom_facts_dir"
	cat << EOF2 > "${ansible_custom_facts_dir}/iocage.fact"
#!/bin/sh
cat << EOF
{
  "iocage_plugin_name": "$plugin_name"
}
EOF
EOF2
	chmod a+x "${ansible_custom_facts_dir}/iocage.fact"
	# Ansible needs UTF-8
	echo "LC_ALL=en_US.UTF-8" >> /root/.profile
	# Configure and start syslog-ng server
	mkdir /root/ansible-conf-syslogng-server
	cd /root/ansible-conf-syslogng-server
	ansible-pull -i hosts -U https://github.com/vbotka/ansible-conf-syslogng-server.git -d /root/ansible-conf-syslogng-server /root/ansible-conf-syslogng-server/pb-logserv.yml
	;;
    ansible-test)
	cat << EOF > /root/PLUGIN_INFO
plugin_name: $plugin_name
plugin_ip: $IOCAGE_PLUGIN_IP
EOF
	mkdir -p "$ansible_custom_facts_dir"
	cat << EOF2 > "${ansible_custom_facts_dir}/iocage.fact"
#!/bin/sh
cat << EOF
{
  "iocage_plugin_name": "$plugin_name"
}
EOF
EOF2
	chmod a+x "${ansible_custom_facts_dir}/iocage.fact"
	echo "LC_ALL=en_US.UTF-8" >> /root/.profile
	;;
    ansible-pull-syslogng-client)
	# Create custom facts
	mkdir -p "$ansible_custom_facts_dir"
	cat << EOF2 > "${ansible_custom_facts_dir}/iocage.fact"
#!/bin/sh
cat << EOF
{
  "iocage_plugin_name": "$plugin_name"
}
EOF
EOF2
	chmod a+x "${ansible_custom_facts_dir}/iocage.fact"
	# Ansible needs UTF-8
	echo "LC_ALL=en_US.UTF-8" >> /root/.profile
	# Configure syslog-ng client
	mkdir /root/ansible-conf-syslogng-client
	cd /root/ansible-conf-syslogng-client
	ansible-pull -i hosts -U https://github.com/vbotka/ansible-conf-syslogng-client.git -d /root/ansible-conf-syslogng-client pb-logclient.yml
	;;
    ansible-pull-syslogng-server)
	# Create custom facts
	mkdir -p "$ansible_custom_facts_dir"
	cat << EOF2 > "${ansible_custom_facts_dir}/iocage.fact"
#!/bin/sh
cat << EOF
{
  "iocage_plugin_name": "$plugin_name"
}
EOF
EOF2
	chmod a+x "${ansible_custom_facts_dir}/iocage.fact"
	# Ansible needs UTF-8
	echo "LC_ALL=en_US.UTF-8" >> /root/.profile
	# Configure syslog-ng server
	mkdir /root/ansible-conf-syslogng-server
	cd /root/ansible-conf-syslogng-server
	ansible-pull -i hosts -U https://github.com/vbotka/ansible-conf-syslogng-server.git -d /root/ansible-conf-syslogng-server pb-logserv.yml
	;;
    ansible-pull-test)
	mkdir -p "$ansible_custom_facts_dir"
	cat << EOF2 > "${ansible_custom_facts_dir}/iocage.fact"
#!/bin/sh
cat << EOF
{
  "iocage_plugin_name": "$plugin_name"
}
EOF
EOF2
	chmod a+x "${ansible_custom_facts_dir}/iocage.fact"
	echo "LC_ALL=en_US.UTF-8" >> /root/.profile
	;;
    ansible-zero)
	;;
esac
