import importlib.util
from importlib.metadata import version


def package_installed(package_name):
    if importlib.util.find_spec(package_name) is not None:
        print(f"{package_name} {version(package_name)} is installed.")
    else:
        print(f"{package_name} is not installed.")


package_names = ["numpy", "matplotlib", "seaborn"]
for p in package_names:
    package_installed(p)
