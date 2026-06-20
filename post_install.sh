#!/bin/sh

plugin_name=$(hostname)
ansible_custom_facts_dir="/etc/ansible/facts.d"

case "$plugin_name" in
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Configure syslog-ng client
        ansible-pull \
            -i hosts \
            -U https://github.com/vbotka/ansible-conf-syslogng-client.git \
            -d /root/ansible-conf-syslogng-client \
            -e "ansible_pull_mode=true" \
            pb-logclient.yml
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Configure syslog-ng server
        ansible-pull \
            -i hosts \
            -U https://github.com/vbotka/ansible-conf-syslogng-server.git \
            -d /root/ansible-conf-syslogng-server \
            -e "ansible_pull_mode=true" \
            pb-logserv.yml
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ansible-pull-test)
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
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Test ansible-pull
        ansible-pull \
            -i hosts \
            -U https://github.com/vbotka/ansible-conf-test.git \
            -d /root/ansible-conf-test \
            -e "ansible_pull_mode=true" \
            pb-test.yml
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ansible-pull-init)
        # Create custom facts.
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
        # Ansible needs UTF-8.
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Test init configuration.
        ansible-pull \
	    -i hosts \
	    -U https://github.com/vbotka/ansible-conf-init.git \
	    -d /root/ansible-conf-init \
            -e "ansible_pull_mode=true" \
	    pb-init.yml
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ansible-test)
        # Create PLUGIN_INFO
        cat << EOF > /root/PLUGIN_INFO
plugin_name: $plugin_name
plugin_ip: $IOCAGE_PLUGIN_IP
EOF
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
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ansible-zero)
        ;;
esac
