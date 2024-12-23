kubectl apply -f cluster-pod-reader.yaml
openssl genrsa -out user1.key 2048
openssl req -new -key user1.key -out user1.csr -subj "/CN=user1"
cat user1.csr | base64 | tr -d "\n" > user1-base64.csr
kubectl apply -f certificate-signing-request-user1.yaml
kubectl certificate approve user1
kubectl get certificatesigningrequests user1 -o jsonpath='{ .status.certificate }' | base64 --decode > user1.crt
kubectl config set-cluster kubernetes-user1 --server=https://192.168.121.130:6443 --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true --kubeconfig=user1.conf
kubectl config set-credentials user1 --client-key=user1.key --client-certificate=user1.crt --embed-certs=true --kubeconfig=user1.conf
kubectl config set-context user1@kubernetes-user1 --cluster=kubernetes-user1 --user=user1 --kubeconfig=user1.conf
kubectl apply -f cluster-pod-reader-role-binding.yaml
