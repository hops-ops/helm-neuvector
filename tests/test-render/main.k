import models.io.upbound.dev.meta.v1alpha1 as metav1alpha1
import models.k8s.apimachinery.pkg.apis.meta.v1 as metav1

# ==============================================================================
# Unit tests for NeuVector XRD
# ==============================================================================

_items = [
    # ==========================================================================
    # Test 1: Minimal input renders Helm release
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "minimal-renders-helm-release"
        spec = {
            compositionPath = "apis/neuvectors/composition.yaml"
            xrdPath = "apis/neuvectors/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "NeuVector"
                metadata.name = "test-neuvector"
                spec = {
                    clusterName = "test-cluster"
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "test-neuvector"
                }
            ]
        }
    }

    # ==========================================================================
    # Test 2: Custom labels are applied and merged with defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "custom-labels-merged-with-defaults"
        spec = {
            compositionPath = "apis/neuvectors/composition.yaml"
            xrdPath = "apis/neuvectors/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "NeuVector"
                metadata.name = "labeled-neuvector"
                spec = {
                    clusterName = "test-cluster"
                    labels = {
                        team = "security"
                        environment = "staging"
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata = {
                        name = "labeled-neuvector"
                        labels = {
                            "hops.ops.com.ai/managed" = "true"
                            "hops.ops.com.ai/neuvector" = "labeled-neuvector"
                            team = "security"
                            environment = "staging"
                        }
                    }
                }
            ]
        }
    }

    # ==========================================================================
    # Test 3: overrideAllValues replaces defaults
    # ==========================================================================
    metav1alpha1.CompositionTest {
        metadata.name = "override-all-values"
        spec = {
            compositionPath = "apis/neuvectors/composition.yaml"
            xrdPath = "apis/neuvectors/definition.yaml"
            timeoutSeconds = 60
            validate = False
            xr = {
                apiVersion = "helm.hops.ops.com.ai/v1alpha1"
                kind = "NeuVector"
                metadata.name = "override-test"
                spec = {
                    clusterName = "my-cluster"
                    overrideAllValues = {
                        fullnameOverride = "custom-neuvector"
                        controller.replicas = 1
                    }
                }
            }
            assertResources = [
                {
                    apiVersion = "helm.m.crossplane.io/v1beta1"
                    kind = "Release"
                    metadata.name = "override-test"
                    spec.forProvider.values = {
                        fullnameOverride = "custom-neuvector"
                        controller.replicas = 1
                    }
                }
            ]
        }
    }
]

items = _items
