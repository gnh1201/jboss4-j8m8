# jboss4-j8m8
Dockerfile for JBoss 4 with Oracle JDK 8 and MySQL 8

## How to use
- docker run -d -p 8000:8000 -p 8080:8080 -p 9990:9990 [j8m8-image-name]
- connect command line: docker exec -it 123xxxxxx bash (123: first 3 numbers of container name)

## references
- https://hub.docker.com/r/jboss/base/~/dockerfile/
- https://hub.docker.com/r/nimmis/java-centos/
- https://hub.docker.com/r/mysql/mysql-server/
- https://github.com/berlinguyinca/jboss4 ( https://hub.docker.com/r/berlinguyinca/jboss4/ )
- https://github.com/martincallesen/jboss4
