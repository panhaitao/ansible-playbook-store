kubectl delete cm ui-logo -n alauda-system
kubectl create configmap ui-logo -n alauda-system --from-file=logo-login-large.svg --from-file=logo-main.svg --from-file=logo-main-mini.svg --from-file=site-ico.png  --from-file=landing-bg.svg
kubectl get cm ui-logo -n alauda-system -o yaml > rubick-logo-cebbank.yaml

NUM=`sed -n '$=' rubick-logo-cebbank.yaml`
L=$(($NUM-8+1))
sed -i $L,${NUM}d rubick-logo-cebbank.yaml

cat 2.8.head >> rubick-logo-cebbank.yaml

for f in `kubectl get pods  --all-namespaces | grep rubick | awk '{print $2}'`
do
    kubectl delete pod $f -n alauda-system
done
