kubectl apply -f development-role.yaml
openssl genrsa -out user2.key 2048
openssl req -new -key user2.key -out user2.csr -subj "/CN=user2"
cat user2.csr | base64 | tr -d "\n" > user2-base64.csr
kubectl apply -f certificate-signing-request-user2.yaml
kubectl certificate approve user2
kubectl get certificatesigningrequests user2 -o jsonpath='{ .status.certificate }' | base64 --decode > user2.crt
kubectl config set-cluster kubernetes-user2 --server=https://192.168.121.130:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --kubeconfig=user2.conf
kubectl config set-credentials user2 --client-key=user2.key --client-certificate=user2.crt --embed-certs=true --kubeconfig=user2.conf
kubectl config set-context user2@kubernetes-user2 --cluster=kubernetes-user2 --user=user2 --kubeconfig=user2.conf
kubectl apply -f development-role-binding.yaml
