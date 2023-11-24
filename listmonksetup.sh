# /bin/bash

DOCKERCOMPOSEDIRECTORY='/opt/listmonk'

sudo docker-compose up -d
sleep 2

IntallLaunched=$(sudo docker logs listmonk | grep 'config' | wc -l)
IntallFinished=$(sudo docker logs listmonk | grep 'run the program and access the dashboard' | wc -l)

CleanUp=0

echo IntallLaunched: $IntallLaunched
echo IntallFinished: $IntallFinished

while [ $CleanUp -eq 0 ]; do
        IntallLaunchedretest=$(sudo docker logs listmonk | grep 'config' | wc -l)
        IntallFinishedretest=$(sudo docker logs listmonk | grep 'run the program and access the dashboard' | wc -l)


        sleep 5
        echo IntallLaunched: $IntallLaunched
        echo IntallFinished: $IntallFinished

        if [ "$IntallLaunchedretest" -gt 1 ] || [ "$IntallFinishedretest" -gt 1 ]; then
                sudo rm -f listmonk

                        # update docker-compose.yml to not force install
                        sudo cp docker-compose.yml /home/ubuntu/
                        echo "Backup copy of docker compose file to /home/ubuntu/"

                        sudo cp docker-compose.yml /tmp/dc.yml
                # Comment out install command
                        sudo sed -i 's/command:/#command:/g' /tmp/dc.yml
                        sudo mv /tmp/dc.yml $DOCKERCOMPOSEDIRECTORY/docker-compose.yml
                        echo "Docker compose file updated"

                        # Relaunch Listmonk
                        sudo docker-compose up -d

                        # Increment cleanup value to get out of loop
                        CleanUp=$((CleanUp+1))
        fi
done
