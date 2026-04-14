docker-build:
	git pull
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 739561048503.dkr.ecr.us-east-1.amazonaws.com
	docker build -t 739561048503.dkr.ecr.us-east-1.amazonaws.com/analytics-service:latest .
	docker push 739561048503.dkr.ecr.us-east-1.amazonaws.com/analytics-service:latest

eks-deploy:
	aws eks update-kubeconfig --name dev
	helm upgrade -i analytics-service . -f values/analytics-service.yml

