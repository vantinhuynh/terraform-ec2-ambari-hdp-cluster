# Hadoop cluster Terraform templates and Ansible playbooks for Ambari/Hortonworks deployment.

### Requirement
- CentOS 7
### Update
- Specify most cluster configuration variables in "variables.tf".
### Instructions:
- Copy terraform_key folder to your home directory
- Update "variables.tf" with AWS access key and secret key for your IAM account, IAM keypair and local keyfile.
- Ensure terraform is installed (https://www.terraform.io/intro/getting-started/install.html). From the main project directory, run "terraform plan" and correct any errors.
- Execute "terraform apply" and watch the build output.
- Output from the terraform command includes the utility host's private and public dns addresses.
- Connect to the remote instance:
```
$ ssh -i /path/to/private_key centos@[public_dns_addresses]
```

- Checking hosts are up and accepting host authenticity here
```
$ ansible --private-key .ssh/mykey all -m ping
```
- Configure the cluster hosts, ambari server and agents
```
$ ansible-playbook --private-key .ssh/mykey site.yaml

If you get error, please try again until it's success!
```
- Configure the cluster services
```
$ ansible-playbook --private-key .ssh/mykey cluster.yaml
```

- Connect to Ambari in your browser with:
```
http://[public_dns_addresses]:8080    #(default login is admin:admin)
```
...and watch the cluster build!

### Note
```Ansible host inventory and ambari server are automatically generated from terraform output and copied to the utility host for reference. If changes are made to the cluster, it's critical to stop all ambari agents, either re-launch the utility host (to reconstruct the ansiblehosts.txt) or update the ansiblehosts.txt manually, and then re-run the site playbook.```

To stop the agents across the cluster and shut down the ambari server:

```
$ ansible-playbook --private-key .ssh/mykey stopagents.yaml
```

Master nodes are provisioned with MySQL repositories, and can be used to configure Hadoop services. If the number of master nodes changes from 3, the 'blueprints/hostmap.tpl' file will require update to accommodate the appropriate number of masters.

Useful curl commands for manual execution/verification (these steps are completed by the 'cluster' playbook):

List your registered hosts to confirm ambari knows about them:
```
$ curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://[terraform output: "util_private_dns"]:8080/api/v1/hosts
```
Get a list of registered blueprints:
```
$ curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://[terraform output: "util_private_dns"]:8080/api/v1/blueprints
```
Post a blueprint to the Ambari server:
```
$ curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://[terraform output: "util_private_dns"]:8080/api/v1/blueprints/testclus -d @testclus.json
```
Get a list of managed clusters:
```
$ curl -H "X-Requested-By: ambari" -X GET -u admin:admin http://[terraform output: "util_private_dns"]:8080/api/v1/clusters
```
Post a cluster configuration template:
```
$ curl -H "X-Requested-By: ambari" -X POST -u admin:admin http://[terraform output: "util_private_dns"]:8080/api/v1/clusters -d @hostmap.json

{
  "href" : "[terraform output: "util_private_dns"]:8080/api/v1/clusters/testclus/requests/1",
  "Requests" : {
    "id" : 1,
    "status" : "Accepted"
}
```
Reference: https://github.com/ersiko/terraform-hadoop
