#!/bin/sh

# Set a 10-minute timeout globally for all pkg operations in this script
export FETCH_TIMEOUT=600

plugin_name=$(hostname)
ansible_vars="/root/ansible-vars"
ansible_custom_facts_dir="/etc/ansible/facts.d"
net_if=$(route -n get default | awk '/interface:/ {print $2}')

fix_vnet_interface() {
    if [ -n "$net_if" ]; then
        echo "Fixing interface: $net_if"
        ifconfig "${net_if}" -txcsum -rxcsum
        ifconfig "${net_if}" mtu 1400
    else
        echo "Warning: Could not detect default network interface. Network may fail."
    fi
}

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
	# Apply the hardware checksum and MTU bypass.
	fix_vnet_interface
	# Install packages.
	pkg install -y git py311-ansible sudo syslog-ng
        # Ansible needs UTF-8
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Configure syslog-ng client
        ansible-pull \
            -i hosts \
            -U https://github.com/vbotka/ansible-conf-syslogng-client.git \
            -d /root/ansible-conf-syslogng-client \
            -e "ai_pull_mode=true" \
            -e "ai_vars=${ansible_vars}" \
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
	# Apply the hardware checksum and MTU bypass.
	fix_vnet_interface
	# Install packages.
	pkg install -y git lnav py311-ansible sudo syslog-ng
        # Ansible needs UTF-8
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Configure syslog-ng server
        ansible-pull \
            -i hosts \
            -U https://github.com/vbotka/ansible-conf-syslogng-server.git \
            -d /root/ansible-conf-syslogng-server \
            -e "ai_pull_mode=true" \
            -e "ai_vars=${ansible_vars}" \
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
	# Apply the hardware checksum and MTU bypass.
	fix_vnet_interface
	# Install packages.
	pkg install -y git py311-ansible sudo
        # Ansible needs UTF-8
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Test ansible-pull
        ansible-pull \
            -i hosts \
            -U https://github.com/vbotka/ansible-conf-test.git \
            -d /root/ansible-conf-test \
            -e "ai_pull_mode=true" \
            -e "ai_vars=${ansible_vars}" \
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
	# Apply the hardware checksum and MTU bypass.
	fix_vnet_interface
	# Install packages.
	pkg install -y git py311-ansible sudo
        # Ansible needs UTF-8.
        echo "LANG=en_US.UTF-8" >> /root/.profile
        echo "LC_ALL=en_US.UTF-8" >> /root/.profile
        # Test init configuration.
        ansible-pull \
	    -i hosts \
	    -U https://github.com/vbotka/ansible-conf-init.git \
	    -d /root/ansible-conf-init \
            -e "ai_pull_mode=true" \
            -e "ai_vars=${ansible_vars}" \
	    pb-init.yml
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ansible-test)
        # Create PLUGIN_INFO
        cat << EOF > /root/PLUGIN_INFO
plugin_name: $plugin_name
plugin_ip: $IOCAGE_PLUGIN_IP
EOF
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
	# Apply the hardware checksum and MTU bypass.
	fix_vnet_interface
	# Install packages.
	pkg install -y git py311-ansible sudo
        ;;
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    ansible-zero)
        ;;
esac
