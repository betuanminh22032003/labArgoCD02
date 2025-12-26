# ============================================================
# CLEANUP SCRIPT - Xóa tất cả resources của lab
# ============================================================
# File: cleanup.ps1
# Chạy: .\cleanup.ps1
# ============================================================

Write-Host "=========================================="
Write-Host "🧹 Cleaning up Lab 03 resources..."
Write-Host "=========================================="
Write-Host ""

# Delete namespaces (this will delete all resources in them)
Write-Host "Deleting namespaces..."
kubectl delete namespace waves-demo --ignore-not-found --timeout=60s
kubectl delete namespace health-demo --ignore-not-found --timeout=60s

# Delete ArgoCD applications if they exist
Write-Host ""
Write-Host "Deleting ArgoCD applications..."
kubectl delete application sync-waves-demo -n argocd --ignore-not-found
kubectl delete application health-demo -n argocd --ignore-not-found

Write-Host ""
Write-Host "✅ Cleanup complete!"
Write-Host ""
