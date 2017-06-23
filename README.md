# vagrant-devhub
Docker files to provision DevHub servers.

The project consists of a Doccker compose configuration, consisting of two parts:
* A DevHub server with an internal Git API microservice backed by Gitolite;
* A Build server with a Docker host which can be used for enabling Continuous Integration for DevHub.

*Both machines share your `~/.ssh` key folder.
The SSH public key is used by Gitolite as a master key, so you are allowed to SSH to the Git daemon and administration repository.
The SSH private key is used by the Git API server, in order to obtain R/W access to Gitolite repositories.
Furthermore, the private key is used by the Build server, which uses it in order to obtain read access to the repositories.
Your local SSH key essentially becomes the master key for Devhub.
If you want to use another SSH key for the machines, modify the `.ssh` volume binding in the Compose file.*

## Install
Ensure that you have Docker installed on your local system.

## Login to Devhub
The administrator user is `admin` / `admin`, installed as `cn=admin,dc=devhub,dc=local` in openldap.
This user can be used to log in to DevHub, but also to add new users to the DevHub instance.

### Adding new users
Through `ldapadd` additional users can be added.

In order to do so, first create an `.ldiff` file, containing the changes for the LDAP directory.
First, ensure that the Base DN is created.

```
dn: dc=devhub,dc=local
objectClass: top
objectClass: dcObject
objectClass: organization
dc: devhub
o: Devhub
```

In the next step, we add a user to our `.ldiff` file:

```
dn: uid=jgmeligmeyling,dc=devhub,dc=local
cn: Jan-Willem Gmelig Meyling
givenName: Jan-Willem
sn: Gmelig Meyling
uid: jgmeligmeyling
mail: j.gmeligmeyling@student.tudelft.nl
objectClass: top
objectClass: shadowAccount
objectClass: inetOrgPerson
objectClass: organizationalPerson
objectClass: person
userPassword: password
```

Login to the DevHub VM and execute the following commands.

```sh
vagrant ssh devhub # SSH into the Devhub VM
sudo apt-get -y install ldap-utils # install LDAP utils
ldapadd -cxWD cn=admin,dc=devhub,dc=local -f input.ldiff
```

For more information, see: https://help.ubuntu.com/lts/serverguide/openldap-server.html .

### Using another directory server
It is possible to connect DevHub to an external LDAP directory, such as Active Directory.
The parameters which DevHub uses to connect to the LDAP server are defined in `devhub-server.properties`.

## Docker API protection
For security, the Docker API for the build server is configured with a [client certificate](https://docs.docker.com/engine/security/https/).
Without this security, build containers would technically be able to connect to the Docker API on the host.
The HTTPS certificates are created in the provisioning process using a self-signed CA.
By default the issued certificate expires after one year.
It is possible to exchange the default certificates by storing them under `/etc/docker/tls` for the server certificates and `/build/.docker` for the client certificates.
