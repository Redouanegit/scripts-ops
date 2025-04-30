# Impact Analysis: Migration from SLB to HAProxy (with TrafficManager Constraints)

## 1. Current Architecture Overview

- **Primary JFrog Cluster**:
  - Deployed in `fr-paris`, across two Availability Zones.
  - Fronted by **two managed SLBs** (Service Load Balancers).

- **Disaster Recovery (DR) Cluster**:
  - Deployed in `fr-north`, also behind a **managed SLB**.

- **TrafficManager**:
  - A global DNS-based routing service.
  - Performs **health-based failover** across the three SLBs.
  - **Only supports SLB-type members** for routing targets.

---

## 2. Objective of the Change

Due to observed **instability in the managed SLB service**, we aim to evaluate the feasibility and impact of replacing the SLBs in `fr-paris` with **self-managed HAProxy** instances.

---

## 3. Key Impact Areas

### 3.1 Compatibility with TrafficManager

- **Limitation**: TrafficManager **only accepts SLBs** as members.
- **Impact**: Replacing SLBs with standalone HAProxy breaks routing functionality.
- **Mitigation**: 
  - Deploy HAProxy behind a **lightweight SLB** that acts as a passthrough (Layer 4 or Layer 7).
  - This preserves compatibility with TrafficManager’s routing and failover.

---

### 3.2 Network & Connectivity

- **Impact**: Existing network rules are scoped to SLB IPs.
- **Mitigation**:
  - Maintain SLB fronting HAProxy to avoid modifying ACLs and firewall rules.
  - If HAProxy is exposed directly, all consumer endpoints and rules must be updated.

---

### 3.3 High Availability & Scalability

- **SLB Benefits**: Built-in multi-AZ failover and auto-scaling.
- **With HAProxy**:
  - Deploy **at least two** instances across AZs.
  - Implement **failover mechanisms** (e.g., Keepalived or VRRP).
  - Ensure proper load balancing and scaling strategies.

---

### 3.4 Monitoring & Operations

- **Impact**: Transition to HAProxy shifts monitoring responsibility to internal teams.
- **Required Actions**:
  - Set up monitoring (e.g., Prometheus, Grafana).
  - Enable health checks, log aggregation, and alerts.
  - Implement certificate lifecycle management if terminating TLS in HAProxy.

---

### 3.5 TLS Termination & Security

- **Impact**: SLBs may handle TLS, DDoS protection, and basic WAF.
- **Mitigation**:
  - Configure **TLS termination** in HAProxy with secure ciphers.
  - Assess need for upstream DDoS mitigation or additional WAF capabilities.

---

## 4. Recommended Architecture Adjustment

To maintain TrafficManager integration while introducing HAProxy, we recommend:

> **Deploying HAProxy instances behind a lightweight SLB**, which remains registered with TrafficManager.

This hybrid model preserves DNS failover while enabling greater control of routing logic via HAProxy.

---

## Next Steps

1. Design and test HAProxy configuration (load balancing, TLS, health checks).
2. Deploy HAProxy in HA mode across AZs.
3. Place HAProxy behind a lightweight SLB.
4. Validate failover behavior via TrafficManager.
5. Gradually shift production traffic and monitor.
