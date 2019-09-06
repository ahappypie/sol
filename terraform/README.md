# Terraform
[Terraform], HashiCorp's declarative infrastructure tool.

### Prerequisites
* `jq`, the command-line JSON parser - `brew install jq`/`apt install jq` or equivalent
* `gojsontoyaml`, convert JSON to YAML - `go get github.com/brancz/gojsontoyaml`
* DO Personal Access Token
* SSH Key uploaded to DigitalOcean

### Project Tree
* `templates`
  * `cloud-init.sh`: script used to bootstrap kubernetes dependencies. Runs the same way on every machine.
  * `do-ccm-master.yaml`:
  * `do-ccm-worker.json`: JSON template that is filled in by `jq`, then converted by `gojsontoyaml`, and uploaded to the worker node as the registration template
  * `do-ccm-worker.yaml`: dummy registration file
  * `master-init.sh`:
  * `user-data.yaml`: cloud-config file. Unused for now.
* `firewall.tf`: declares DigitalOcean firewalls
* `nodes.tf`: declares DigitalOcean nodes and steps through the provisioning process
* `output.tf`: declares `terraform` output variables
* `plan.md`: original notes on how to bootstrap a DigitalOcean Kubernetes cluster
* `provider.tf`: `terraform` provider declaration
* `README.md`: this file
* `tags.tf`: declares DigitalOcean tags
* `upgrade-master.sh`: steps to upgrade Kubernetes version on a master node
* `upgrade-worker.sh`: steps to upgrade Kubernetes version on a worker node
* `wait-port.sh`: utility script that waits for an arbitrary port of an arbitrary machine to become available

### Terraform Walkthrough

## Looking for Help
I'm sure there are additional customizations that could be baked in here by default. Feel free to suggest them!

Very much looking forward to the [Cluster API](https://github.com/kubernetes-sigs/cluster-api). Upgrades are still a major pain point, and overall this process requires too many secrets to be copied down to disk (multiple disks!). Terraform is bad at waiting for things. As always, pull requests are welcome.
