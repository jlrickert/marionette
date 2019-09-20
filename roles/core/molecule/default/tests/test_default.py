import os
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_packages(host):
    for name in ["ssh", "python3", "python3-pip"]:
        pkg = host.package(name)
        assert pkg.is_installed


def test_user(host):
    user = host.user("jlrickert")
    assert os.path.exists(os.path.join(user.home, ".ssh"))
    assert user.shell == "/usr/bin/zsh"
    assert "sudo" in user.groups
