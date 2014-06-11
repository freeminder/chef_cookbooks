#!/bin/bash
# Usage: $1 = host, $2 = client or server
# Example: ./pre-install.sh 10.0.0.151 server
cat install.sh | ssh root@$1 "cat > /tmp/install_script ; chmod 755 /tmp/install_script ; /tmp/install_script $2; rm -f /tmp/install_script"
