# Build new release

1. Make sure `src/main/resources/META-INF/persistence.xml` has correct DB URLs (host, db name, username and password)

2. Update pom.xml with version and create a new Git TAG with new version (i.e. `2.8.0`)

3. Build the docker image

```bash
docker compose up --build
```

4. Log in into the container 

```bash
docker exec -ti informea_odata bash
```

5. Compile the new release

```bash
mvn package
```

6. Copy the WAR archive from inside the container

```bash
docker cp informea_odata:/project/target/informea-2.8.0.war .
```

This war can be uploaded as artifact to GitHub and used as app archive in Tomcat.
