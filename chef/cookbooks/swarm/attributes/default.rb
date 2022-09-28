# Version of the Swarm container to use
default['swarm']['swarm_version'] = 'latest'
# Timeout for image pull
default['swarm']['image']['read_timeout'] = 180

# Swarm discovery provider type to use. Valid values are
# token, consul, etcd, zk, file
default['swarm']['discovery']['provider'] = 'token'
# Discovery token to use, only used with provider "token"
default['swarm']['discovery']['token'] = 'd033e1b6ac4999a5bf2553d7fd9aeefc'
# Path to discovery file. Only used for provider "file"
default['swarm']['discovery']['file_path'] = nil
# Specify a host running the discovery service for the Swarm cluster
# If not specified then a search will be run instead
# Only used with provider "consul", "etcd" or "zk"
default['swarm']['discovery']['host'] = '34.128.107.112'
# Specify a port for your discovery service. This can be used in combination with
# ['swarm']['discovery']['host'] or with search. It need not be used at all if your
# discovery provider is running on standard ports that can be inferrred from the protocol
default['swarm']['discovery']['port'] = nil
# When a discovery host is not specified the cookbook will attempt to find a discovery
# provider using the specified query
# Only used with provider "consul", "etcd" or "zk"
default['swarm']['discovery']['query'] = "role:swarm-discovery AND chef_environment:#{node.chef_environment}"
# Path to append to the end of the key value store URL
# Only used with provider "consul", "etcd" or "zk"
default['swarm']['discovery']['path'] = nil

# Swarm container restart policy
default['swarm']['restart_policy'] = 'on-failure'
# Discovery options passed in to the swarm containers
default['swarm']['discovery_options'] = []

default['swarm']['manager']['bind'] = '0.0.0.0'
default['swarm']['manager']['port'] = 3376
default['swarm']['manager']['advertise'] = node['ipaddress']
default['swarm']['manager']['strategy'] = 'spread'
default['swarm']['manager']['replication'] = false
default['swarm']['manager']['replication_ttl'] = '30s'
default['swarm']['manager']['heartbeat'] = nil
default['swarm']['manager']['cluster_driver'] = 'swarm'
# Cluster driver options
default['swarm']['manager']['cluster_options'] = []
# Hook for adding additional arguments to the swarm manage command
# Specified as a Hash of argument names to values
default['swarm']['manager']['additional_options'] = {}

default['swarm']['worker']['advertise'] = node['ipaddress']
default['swarm']['worker']['ttl'] = nil
default['swarm']['worker']['heartbeat'] = nil
default['swarm']['worker']['delay'] = nil
# Hook for adding additional arguments to the swarm join command
# Specified as a Hash of argument names to values
default['swarm']['worker']['additional_options'] = {}
