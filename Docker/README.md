Here is the list of Docker examples we built:

- [Airflow](/Airflow/)

### Important Docker terminal commands:

1. Docker version: `docker --version`
2. Docker info: `docker info`
3. Docker help: `docker help`
4. Pull an Image from Docker Hub: `docker pull image_name:tag`
5. List Local Docker Images: `docker images`
6. Run a Container: `docker run image_name`
7. List Running Containers: `docker ps`
8. List All Containers (including stopped ones): `docker ps -a`
9. Stop a Running Container: `docker stop container_name_or_id`
10. Remove a Container: `docker rm container_name_or_id`
11. Remove an Image: `docker rmi image_name:tag`
12. View Container Logs: `docker logs container_name_or_id`
13. Execute a Command Inside a Running Container: `docker exec -it container_name_or_id command`
14. Inspect a Container: `docker inspect container_name_or_id`
15. Build an Image from a Dockerfile: `docker build -t image_name:tag path_to_dockerfile_directory`
16. Push an Image to Docker Hub: `docker push image_name:tag`
17. Create a Docker Network: `docker network create network_name`
18. List Docker Networks: `docker network ls`
19. Remove a Docker Network: `docker network rm network_name`
20. Prune Unused Resources: `docker system prune`
