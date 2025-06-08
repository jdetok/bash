SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin

#!/bin/bash

sudo systemctl status pihole-FTL.service > output.txt

if grep -q "running" output.txt && ! grep -q "inactive" output.txt; then    
echo "Pi-Hole is running"
else
sudo systemctl start pihole-FTL.service 

echo "Pi-Hole was inactive. The service has been started." 
fi

sudo rm -f output.txt