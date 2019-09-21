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
    assert user.shell == "/usr/bin/zsh"
    assert "sudo" in user.groups

    # TODO: fails on azure for some reason
    # assert os.path.exists(os.path.join(user.home, ".ssh"))
    # assert os.path.exists(user.home)


def test_dotfiles(host):
    assert host.package("chezmoi").is_installed
    chezmoi_config = host.file("/home/jlrickert/.config/chezmoi/chezmoi.toml")
    assert chezmoi_config.contains("signing_key")
    assert chezmoi_config.contains('name = "Jared Rickert"')
    assert chezmoi_config.contains('email = "jaredrickert52@gmail.com"')
    assert host.file("/home/jlrickert/.gitconfig").contains(
        'name = "Jared Rickert"')
