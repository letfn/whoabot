def test_packages_are_installed(host):
    for p in "tini make git curl rsync".split(" "):
        pkg = host.package(p)
        assert pkg.is_installed
