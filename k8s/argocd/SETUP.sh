# ArgoCD Image Updater — Install & Setup
#
# Run these commands ONCE to set up Image Updater in your cluster.
# After this, everything is driven by annotations in your Application manifests.

# ── 1. Install ArgoCD Image Updater ────────────────────────────────────────────
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/config/install.yaml
# Verify it's running
kubectl get pods -n argocd | grep image-updater


# ── 2. Apply the git-creds secret ──────────────────────────────────────────────
# ⚠️  Edit argocd/git-creds-secret.yaml first:
#     - Set <GITHUB_USERNAME>
#     - Set <GITHUB_PAT_TOKEN>  (needs 'repo' scope)
kubectl apply -f k8s/argocd/git-creds-secret.yaml

# ── 3. Apply your ArgoCD Applications ──────────────────────────────────────────
# ⚠️  Edit both application-*.yaml first:
#     - Set <GITHUB_USERNAME>  (GitHub repo URL)
#     - Set <DOCKERHUB_USERNAME>
kubectl apply -f k8s/argocd/application-dev.yaml
kubectl apply -f k8s/argocd/application-prod.yaml
kubectl apply -f k8s/argocd/image-updater.yaml

# ── 4. Verify Image Updater is watching the apps ──────────────────────────────
kubectl logs -n argocd deployment/argocd-image-updater-controller -f

