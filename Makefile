argocd_server := $(shell kubectl get svc argocd-server  -o jsonpath='{.status.loadBalancer.ingress[].hostname}')
argocd_admin_password := $(shell kubectl get secrets argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)

docker-build:
	git pull
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 739561048503.dkr.ecr.us-east-1.amazonaws.com
	docker build -t 739561048503.dkr.ecr.us-east-1.amazonaws.com/analytics-service:$(image_tag) .
	docker push 739561048503.dkr.ecr.us-east-1.amazonaws.com/analytics-service:$(image_tag)

eks-deploy:
	aws eks update-kubeconfig --name dev
	helm upgrade -i analytics-service helm -f helm/values/analytics-service.yml --set image_tag=$(image_tag)

argocd-deploy:
	aws eks update-kubeconfig --name dev
	argocd login $(argocd_server) --insecure --username admin --password $(argocd_admin_password)
	argocd app create analytics-service --sync-policy manual --repo https://github.com/raghudevopsb88/wmp-helm-v1.git --path . --dest-server https://kubernetes.default.svc   --dest-namespace default --helm-set-string image_tag=$(image_tag) --values values/analytics-service.yml
