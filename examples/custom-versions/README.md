# Custom Versions Example

This example demonstrates version management strategies for the Kubernetes Gateway API module, including how to deploy specific versions, upgrade versions, test multiple versions simultaneously, and manage version compatibility.

## Overview

Version management is critical for maintaining stability and compatibility in production environments. This example shows various strategies for controlling which versions of the Gateway API and Helm chart are deployed.

## Version Components

The Gateway API deployment has three version-related components:

### 0. Module Version
- **Current**: `1.0.0` (tf-kubernetes-iaac/api/gateway)
- **Purpose**: The Terraform module version controlling module features
- **Location**: Controlled by `version` in module block

### 1. Helm Chart Version
- **Current**: `0.2.0`
- **Purpose**: Container for the Gateway API CRDs and installer
- **Impact**: Updates to the installer and deployment mechanism
- **Location**: Controlled by `chart_version` variable

### 2. Gateway API Version
- **Current**: `1.5.0`
- **Purpose**: The actual Kubernetes Gateway API specification version
- **Impact**: Available resource types and features
- **Location**: Controlled by `gateway_version` variable

## Usage Scenarios

### Scenario 1: Deploy Latest Stable Versions (Default)

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-latest"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "standard"
}
```

**Use Case**: Production environments that want regular updates with stability

**Deploy**:
```bash
terraform apply
```

### Scenario 2: Lock to Specific Versions

Pin versions to ensure reproducibility:

```hcl
module "gateway_api_pinned" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-prod"
  chart_version     = "0.2.0"
  gateway_version   = "1.5.0"
  channel           = "standard"
}
```

**Use Case**: Production environments requiring controlled change management

**Deploy**:
```bash
terraform apply
```

### Scenario 3: Test Experimental Features

```hcl
module "gateway_api_experimental" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  helm_release_name = "gateway-api-experimental"
  chart_version     = "0.2.0"
  gateway_version   = "1.6.0"
  channel           = "experimental"
}
```

**Use Case**: Development/testing environment to evaluate new features before production adoption

**Deploy**:
```bash
terraform apply
```

### Scenario 4: Side-by-Side Version Testing

Deploy multiple versions simultaneously for testing:

```hcl
module "gateway_api_v1_5" {
  source  = \"tf-kubernetes-iaac/api/gateway\"
  version = \"1.0.0\"
  
  helm_release_name = \"gateway-api-v1-5\"
  gateway_version   = \"1.5.0\"
}

module \"gateway_api_v1_6\" {
  source  = \"tf-kubernetes-iaac/api/gateway\"
  version = \"1.0.0\"
  
  helm_release_name = "gateway-api-v1-6"
  gateway_version   = "1.6.0"
}
```

**Use Case**: Gradual migration, testing, or maintaining multiple versions

**Deploy**:
```bash
terraform apply
```

## Version Compatibility Matrix

| Gateway API | Chart | Channel | Status |
|------------|-------|---------|--------|
| 1.5.0 | 0.2.0 | standard | ✅ Stable |
| 1.6.0 | 0.3.0 | standard | ✅ Stable |
| 1.6.0 | 0.3.0 | experimental | ⚠️ Testing |
| 1.7.0 | 0.4.0 | experimental | ⚠️ Pre-release |

## Version Update Workflow

### Step 1: Check Available Versions

```bash
# List available versions from the chart repository
helm search repo gateway-api --versions

# Or check the nicklasfrahm/charts repository
# https://github.com/nicklasfrahm/charts
```

### Step 2: Plan Testing

1. **Identify target version** (e.g., 1.6.0)
2. **Check release notes** for breaking changes
3. **Verify compatibility** with your applications
4. **Test in non-production** first

### Step 3: Update Configuration

Edit `main.tf` to change versions:

```hcl
module "gateway_api" {
  source  = "tf-kubernetes-iaac/api/gateway"
  version = "1.0.0"
  
  gateway_version = "1.6.0"  # Updated from 1.5.0
  chart_version   = "0.3.0"  # Updated from 0.2.0
}
```

### Step 4: Review Changes

```bash
terraform plan
```

Carefully review the plan output to understand what will change.

### Step 5: Apply Changes

```bash
terraform apply
```

### Step 6: Monitor Deployment

```bash
# Watch the rollout
kubectl rollout status deployment/gateway-api-controller -n gateway-api-system

# Check pod logs
kubectl logs -n gateway-api-system -l app=gateway-api-controller -f
```

## Version Download and Verification

### Viewing Chart Contents

```bash
# Inspect chart before deploying
helm show chart oci://ghcr.io/nicklasfrahm/charts/gateway-api --version 0.2.0

# View chart values
helm show values oci://ghcr.io/nicklasfrahm/charts/gateway-api --version 0.2.0
```

### Verifying Deployed Version

```bash
# Get deployed versions
helm get values gateway-api-stable | grep version

# Check CRDs version
kubectl get crd gateways.gateway.networking.k8s.io -o yaml | grep apiVersion

# Check all Gateway API resources
kubectl get all -n gateway-api-system
```

## Managing Version Updates

### Safe Update Process

1. **Stage Update in Development**
   ```bash
   # Update in dev environment
   terraform apply -var-file="dev.tfvars"
   ```

2. **Test Thoroughly**
   ```bash
   # Deploy test applications
   # Verify functionality
   # Check for deprecations
   ```

3. **Schedule Production Update**
   ```bash
   # Create a maintenance window
   # Notify stakeholders
   ```

4. **Execute Update**
   ```bash
   terraform plan
   terraform apply
   ```

5. **Verify Production**
   ```bash
   # Monitor logs and metrics
   # Test critical paths
   # Confirm stability
   ```

### Rollback Process

If issues occur after update:

```bash
# Revert to previous version in configuration
# Edit main.tf and change versions back

terraform plan  # Review rollback
terraform apply # Execute rollback

# Or use Helm directly
helm rollback gateway-api-stable 1  # Rollback to previous release
```

## Channel Selection

### Standard Channel
- **Stability**: ✅ Production-ready
- **Release Cycle**: Quarterly
- **Support**: Full support
- **Risk Level**: Low
- **Use For**: Production environments

### Experimental Channel
- **Stability**: ⚠️ May have issues
- **Release Cycle**: Frequent
- **Support**: Community support
- **Risk Level**: High
- **Use For**: Development, testing, beta features

## Version Pinning Strategies

### Flexible Pinning
Allow patch version updates:

```hcl
# This would use 0.2.x when available
chart_version = "~0.2.0"
```

### Strict Pinning
Lock to exact version:

```hcl
chart_version = "0.2.0"
```

### Latest Version
Use the most recent version:

```hcl
# Not usually recommended for production
gateway_version = "latest"
```

## Breaking Changes Management

Monitor for breaking changes during version upgrades:

### Before Upgrading

1. **Read Release Notes**
   ```bash
   # Check https://gateway-api.sigs.k8s.io/
   ```

2. **Test Compatibility**
   ```bash
   # Test in staging environment
   terraform apply -var-file="staging.tfvars"
   ```

3. **Update Applications** (if needed)
   - Check for API deprecations
   - Update resource manifests
   - Test application compatibility

### After Upgrading

1. **Verify Resources**
   ```bash
   kubectl get gateways -A
   kubectl get httproutes -A
   ```

2. **Check Application Status**
   ```bash
   kubectl get pods -A
   kubectl logs -n <namespace> <pod>
   ```

3. **Monitor Metrics**
   - Check error rates
   - Monitor latency
   - Review resource usage

## Troubleshooting Version Issues

### Issue: Version Not Found

**Error**: `Error: failed to find chart version 0.5.0`

**Solution**: Check available versions:
```bash
helm search repo gateway-api --versions
```

### Issue: Version Incompatibility

**Error**: `gateway_version 1.7.0 not compatible with chart_version 0.2.0`

**Solution**: Update both to compatible versions:
```hcl
chart_version   = "0.3.0"  # Older chart
gateway_version = "1.6.0"  # Update together
```

### Issue: CRD Version Conflict

**Error**: `error validating: spec.validation.openAPIV3Schema: Invalid value`

**Solution**: CRDs might conflict. Check:
```bash
# List current CRDs
kubectl get crd | grep gateway

# Delete old CRDs if upgrading
kubectl delete crd <old-gateway-crd>
```

## Version History

Maintain a record of version changes in your environment:

```hcl
# Add comments with version history
# 2024-03-01: Updated to 1.5.0 for bug fix
# 2024-02-01: Updated to 1.4.0 for new features
# 2024-01-01: Initial deployment with 1.3.0
```

## Related Examples

- **[Basic Configuration](../basic-configuration/)**: Simple setup
- **[Complete Configuration](../complete-configuration/)**: All options

## Resources

- [Gateway API Releases](https://github.com/kubernetes-sigs/gateway-api/releases)
- [nicklasfrahm/charts Repository](https://github.com/nicklasfrahm/charts)
- [Helm Chart Release Process](https://helm.sh/docs/topics/chart_repository/)
- [Semantic Versioning](https://semver.org/)

## Best Practices

1. **Document Decisions**: Record why specific versions are chosen
2. **Test First**: Always test version updates in non-production
3. **Automate Testing**: Consider CI/CD for version testing
4. **Have Rollback Plan**: Know how to revert if needed
5. **Monitor After Updates**: Watch logs and metrics closely
6. **Update Regularly**: Stay current with security patches
7. **Read Release Notes**: Always review before updating

## Checking for Updates

```bash
# Check for available chart updates
helm search repo gateway-api --versions

# Get current version
helm list | grep gateway-api

# Compare with latest
curl -s https://api.github.com/repos/nicklasfrahm/charts/releases | jq '.[] | .tag_name'
```

## Summary

This example provides templates and strategies for:
- Deploying specific versions
- Testing multiple versions
- Safely updating versions
- Managing version compatibility
- Troubleshooting version issues

Choose the approach that matches your environment's requirements and risk tolerance.
