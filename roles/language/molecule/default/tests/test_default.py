import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_node_version(host):
    node_version = host.run("node --version")
    print(node_version)
    assert node_version.stdout == "v13.0.1\n"
