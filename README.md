# docker-seat-eve
Docker image for https://github.com/eveseat/seat

# Installation

1. Create docker image - `docker build . -t kev/seat`
2. Create environment file - `cp environment.example environment && vi environment`
3. Create mysql container - `docker run --name seat-mysql --env-file=environment -d mysql:8`
4. Create folders for seat data - `mkdir -p data/seat_storage && mkdir -p data/installed`
4. Create seat container - `docker run --name seat -p 80:80 -v `pwd`/data/seat_storage:/storage -v `pwd`/data/installed:/installed --link seat-mysql:mysql --env-file=environment -d kev/seat`
5. Populate seat database - `docker exec -it seat /bin/bash -c /manualinit.sh`
