docker:
	ansible-playbook -i hosts bare.yml --tags docker

nginx:
	ansible-playbook -i hosts bare.yml --tags nginx

nexus:
	ansible-playbook -i hosts repository.metio.wtf.yml --tags nexus

jenkins:
	ansible-playbook -i hosts build.metio.wtf.yml --tags jenkins

sonarqube:
	ansible-playbook -i hosts quality.metio.wtf.yml --tags sonarqube
