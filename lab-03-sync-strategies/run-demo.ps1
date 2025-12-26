# ============================================================
# QUICK DEMO SCRIPT - Chạy lab mà không cần Git repo
# ============================================================
# File: run-demo.ps1
# Chạy: .\run-demo.ps1
# ============================================================

Write-Host "=========================================="
Write-Host "🚀 Lab 03: Sync Waves & Health Demo"
Write-Host "=========================================="
Write-Host ""

# Check if kubectl is available
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "❌ kubectl not found. Please install kubectl first."
    exit 1
}

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ============================================================
# PART 1: Sync Waves Demo
# ============================================================
Write-Host ""
Write-Host "=========================================="
Write-Host "📦 PART 1: Sync Waves Demo"
Write-Host "=========================================="
Write-Host ""

Write-Host "Step 1: Creating namespace (Wave -1)..."
kubectl apply -f "$scriptDir\manifests\sync-waves-demo\01-namespace.yaml"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "Step 2: Creating ConfigMap (Wave 0)..."
kubectl apply -f "$scriptDir\manifests\sync-waves-demo\02-configmap.yaml"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "Step 3: Creating Deployment (Wave 1)..."
Write-Host "   ⏳ ArgoCD would wait for Wave 0 to be healthy here..."
kubectl apply -f "$scriptDir\manifests\sync-waves-demo\03-deployment.yaml"

Write-Host ""
Write-Host "   Waiting for deployment to be ready..."
kubectl rollout status deployment/wave-app -n waves-demo --timeout=60s

Write-Host ""
Write-Host "Step 4: Creating Service (Wave 2)..."
Write-Host "   ⏳ ArgoCD would wait for Wave 1 deployment to be healthy here..."
kubectl apply -f "$scriptDir\manifests\sync-waves-demo\04-service.yaml"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "✅ Sync Waves demo resources created!"
Write-Host ""
Write-Host "📊 Current state:"
kubectl get all -n waves-demo

# ============================================================
# PART 2: Health Demo
# ============================================================
Write-Host ""
Write-Host "=========================================="
Write-Host "🏥 PART 2: Health States Demo"
Write-Host "=========================================="
Write-Host ""

Write-Host "Creating healthy and unhealthy apps..."
kubectl apply -f "$scriptDir\manifests\health-demo\healthy-app.yaml"
kubectl apply -f "$scriptDir\manifests\health-demo\unhealthy-app.yaml"

Write-Host ""
Write-Host "⏳ Waiting 30 seconds for pods to stabilize..."
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "📊 Health Demo Results:"
Write-Host "=========================================="
Write-Host ""
Write-Host "Deployments:"
kubectl get deployments -n health-demo -o wide

Write-Host ""
Write-Host "Pods:"
kubectl get pods -n health-demo

Write-Host ""
Write-Host "=========================================="
Write-Host "📝 Explanation:"
Write-Host "=========================================="
Write-Host ""
Write-Host "🟢 healthy-nginx     - HEALTHY: All pods Running, Ready=2/2"
Write-Host "🟡 unhealthy-app     - DEGRADED: Pods CrashLoopBackOff, Ready=0/2"
Write-Host "🟡 image-not-found   - DEGRADED: ImagePullBackOff, Ready=0/1"
Write-Host ""

# ============================================================
# Summary
# ============================================================
Write-Host "=========================================="
Write-Host "✅ Demo Complete!"
Write-Host "=========================================="
Write-Host ""
Write-Host "What you learned:"
Write-Host "1. Sync Waves control deployment ORDER"
Write-Host "2. Lower wave numbers deploy FIRST (can be negative)"
Write-Host "3. ArgoCD WAITS for each wave to be healthy"
Write-Host "4. Health states: Healthy, Degraded, Progressing"
Write-Host ""
Write-Host "To cleanup, run:"
Write-Host "  kubectl delete namespace waves-demo health-demo"
Write-Host ""
