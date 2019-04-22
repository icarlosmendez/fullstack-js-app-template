
Node + Create React App + PostgreSQL + Docker Compose
========================================

This project runs a Node server, a create-react-app client application, a Postgres db server and a pgAdmin server for db management via four separate containers, all linked via a docker controlled v-lan using Docker Compose. 

This project is largely based on work by mrcoles. Without his efforts this project would have been a lot more difficult and gotten off to a super slow start. Review the original project here... https://github.com/mrcoles/node-react-docker-compose

Expectations for this project are to provide an easily implementable, full-stack, JS-centric application template supported by Docker thereby providing a repeatable solution offering quick setup, iteration and deployment of modern JavaScript based web projects.

As of now, (20APR2019) the project is not hardened in any way with such things as .env files or Docker secrets and the like. This hardening will be implemented eventually but first there will be some testing and development to get an initial data flow to and from the db as well as outlining the most basic UI elements to provide a little scaffolding that goes beyond what `create-react-app` provides upon spin up.


## Development

```
docker-compose up
```

For development, the `node_server/`, `react_client/`, `postgres_server/` and `pgadmin_server/` directories have their own docker containers, which are configured via the `docker-compose.yml` file at the root of this project.

The react_client server is spun up at `localhost:3000` and it proxies internally to the node_server using the linked name of `node_server:8080`.

The local sourcefile directories are bindmounted into the containers, so local changes made in your IDE are reflected in the running containers immediately. To aid in this process NodeMon is also running inside the react_client container and pushing all new changes to the browser upon save. 

One caveat to this is that changes to any of the package.json files, of which there are 3 (project root level, react_client and node_server containers) will likely need a rebuild: 
`docker-compose down && docker-compose up --build`.

### Notes

#### Adding new scss files

The `node-sass` watch feature does not notice new files. In order to get new files working, restart the client container:

```
docker-compose restart client
```

#### Installing npm dependencies

All changes to `node_modules` should happen *inside* the containers. Install any new dependencies from inside the container. You can do this via `docker-compose run`, but it’s easier to just upadte a running container and avoid having to rebuild everything:

```
docker-compose exec client
```

Then inside:

```
npm install --save <new_dependency>
```

## Production

```
docker-compose -f docker-compose.prod.yml up
```

For production, this uses the Dockerfile at the root of the repo. It creates a static build of the client React app and runs Express inside server, which handles both the API and serving of React files.

As a result, different code is executing to serve the React files, but all of the API calls should remain the same. The difference between development and production isn’t ideal, but it does offer the simplicity of having the entire app run in one server on one machine.

This is one of multiple ways a Node + React app could be setup, as suggested [here](https://daveceddia.com/create-react-app-express-production/):

*   __Keep them together__ - have Express serve both the API and React files
*   __Split them apart__ - have Express API on one machine and the React files on another (e.g., on S3 and use CORS to access the API)
*   __Put the API behind a proxy__ - use something like NGINX to proxy the Express API server and React static files separately

This project uses the “keep them together” approach. For better performance, you can set up a proxy (like Cloudflare) in between your server and the Internet to cache the static files. Or with some extra work you can fashion it to do either of the other two options.


## Notes

### Using docker compose

I have `comp` aliased to `docker-compose` on my computer.

Start via:

```
comp up

# or detached
comp up -d
```

Run a container of the server image via:

```
comp run server /bin/bash
```

Check status:

```
comp ps
```

Stop:

```
comp down
```

Run the production image:

```
comp -f docker-compose.prod.yml up
```

NOTE: if any dependencies change in package.json files, you probably will need to rebuild the container for the changes to appear, e.g.,

```
comp down
comp build
comp up
```


### Setup references

References for setting up a Node project with Docker and docker-compose:

*   https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
*   https://blog.codeship.com/using-docker-compose-for-nodejs-development/
*   http://jdlm.info/articles/2016/03/06/lessons-building-node-app-docker.html

Express + React:

*   https://daveceddia.com/create-react-app-express-production/
*   http://ericsowell.com/blog/2017/5/16/create-react-app-and-express
*   https://medium.freecodecamp.org/how-to-make-create-react-app-work-with-a-node-backend-api-7c5c48acb1b0
*   https://medium.freecodecamp.org/how-to-host-a-website-on-s3-without-getting-lost-in-the-sea-e2b82aa6cd38



### Other thoughts on development work

To use or not to use an ORM in your project

*   https://blog.logrocket.com/why-you-should-avoid-orms-with-examples-in-node-js-e0baab73fa5


A little primer on writing Dockerfiles

*   https://blog.hasura.io/an-exhaustive-guide-to-writing-dockerfiles-for-node-js-web-apps-bbee6bd2f3c4/
