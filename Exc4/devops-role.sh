kubectl apply -f devops-role.yaml
openssl genrsa -out user3.key 2048
openssl req -new -key user3.key -out user3.csr -subj "/CN=user3"
cat user3.csr | base64 | tr -d "\n" > user3-base64.csr
kubectl apply -f certificate-signing-request-user3.yaml
kubectl certificate approve user3
kubectl get certificatesigningrequests user3 -o jsonpath='{ .status.certificate }' | base64 --decode > user3.crt
kubectl config set-cluster kubernetes-user3 --server=https://192.168.121.130:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --kubeconfig=user3.conf
kubectl config set-credentials user3 --client-key=user3.key --client-certificate=user3.crt --embed-certs=true --kubeconfig=user3.conf
kubectl config set-context user3@kubernetes-user3 --cluster=kubernetes-user3 --user=user3 --kubeconfig=user3.conf
kubectl apply -f devops-role-binding.yaml
