venv-python: ## Install Python 3 venv
	python3 -m venv venv

venv: venv-python ## Install Python 3 run-time dependencies
	./venv/bin/pip install -r requirements.txt

venv-upgrade: venv-python ## Upgrade Python 3 run-time dependencies
	./venv/bin/pip install --upgrade -r requirements.txt

flathub-repo:
	flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak-pip-generator: venv
	curl https://raw.githubusercontent.com/flatpak/flatpak-builder-tools/master/pip/flatpak-pip-generator -o ./flatpak-pip-generator

glances-full: flatpak-pip-generator
	./venv/bin/python flatpak-pip-generator glances -o python3-glances-full

glances-flatpak-full: glances-full flathub-repo
	flatpak-builder --force-clean --user --install-deps-from=flathub --ccache --require-changes --repo=repo --subject="Build of python3-glances-full, `date`" build com.github.nicolargo.Glances.yml

