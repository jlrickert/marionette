import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_docker(host):
    assert host.package("docker-ce").is_installed

    # TODO: docker instaance doesn't have systemd installed
    # service = host.service("docker")
    # assert service.is_enabled
    # assert service.is_running


def test_docker_user(host):
    user = host.user("jlrickert")
    assert "docker" in user.groups
