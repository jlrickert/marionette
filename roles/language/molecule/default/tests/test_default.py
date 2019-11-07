import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_node_version(host):
    node_version: str = host.run("node --version").stdout
    assert "v13" in node_version, node_version.stdout


def test_scala_version(host):
    scala_version = host.run("sbt --version").stdout
    assert "sbt version" in scala_version, scala_version


def test_java_version(host):
    java_version = host.run("java --version").stdout
    assert "openjdk" in java_version, java_version
