venv-python: ## Install Python 3 venv
	virtualenv -p /usr/bin/python3 venv

venv: venv-python ## Install Python 3 run-time dependencies
	./venv/bin/pip install -r requirements.txt

venv-upgrade: venv-python ## Upgrade Python 3 run-time dependencies
	./venv/bin/pip install --upgrade -r requirements.txt

flatpak-pip-generator: venv
	curl https://raw.githubusercontent.com/flatpak/flatpak-builder-tools/master/pip/flatpak-pip-generator -o ./flatpak-pip-generator

glances-full: flatpak-pip-generator ## Need flatpak-builder (install via apt install flatpak-builder)
	./venv/bin/python flatpak-pip-generator "glances[all]" -o python3-glances-full

glances-flatpak-full: glances-full
	flatpak-builder --force-clean --ccache --require-changes --repo=repo --subject="Build of python3-glances-full, `date`" build com.github.nicolargo.Glances.yml

