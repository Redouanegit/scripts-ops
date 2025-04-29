Impact Analysis – Migration from SLB to HAProxy with TrafficManager Constraints

1. Current Architecture Overview

Primary JFrog Cluster:

Deployed in fr-paris, spread across two Availability Zones.

Fronted by two managed SLBs (Service Load Balancers).


Disaster Recovery (DR) Cluster:

Deployed in fr-north, also behind a managed SLB.


TrafficManager:

A global DNS-based routing service.

Performs health-based failover between the 3 SLBs (2 in fr-paris, 1 in fr-north).

Accepts only SLBs as members, not static IPs or custom instances.




---

2. Objective of the Change

Due to observed instabilities or dysfunctions in the SLB service, evaluate the feasibility and impact of replacing the SLBs in fr-paris with HAProxy, a self-managed load balancing solution.



---

3. Key Impact Areas

3.1 Compatibility with TrafficManager

Critical Limitation: TrafficManager only supports SLB-type resources as routing targets.

Impact: Replacing SLBs directly with HAProxy (standalone) would render TrafficManager unable to route traffic to the primary cluster.

Mitigation:

Deploy HAProxy instances behind a lightweight SLB to maintain TrafficManager compatibility.

SLB acts as a passthrough proxy (L4 or L7) to HAProxy.




---

3.2 Network & Connectivity

Impact: Existing firewall rules and security groups are configured for SLB IPs.

Action Required:

If HAProxy is deployed without SLB, network rules must be updated across environments.

Using SLB in front of HAProxy avoids this disruption (IP continuity, minimal changes).




---

3.3 High Availability & Scalability

SLB Advantage: Native multi-AZ redundancy and auto-scaling.

HAProxy Requirement:

Deploy at least two HAProxy nodes across AZs.

Implement failover mechanisms (e.g., Keepalived, VRRP, DNS, etc.).

Design for load distribution and scalability.




---

3.4 Monitoring & Operations

Impact: Moving from managed SLB to self-hosted HAProxy increases operational responsibility.

Required Actions:

Set up monitoring and alerting (e.g., Prometheus, Grafana, ELK).

Regular updates, log management, SSL renewal handled in-house.




---

3.5 TLS Termination & Security

Impact: Managed SLBs may handle TLS termination and basic DDoS/WAF protections.

Actions:

Implement TLS termination in HAProxy, including certificate management.

Review DDoS protection options (e.g., upstream filtering, rate limiting).




---

4. Recommended Architecture Adjustment

To ensure compatibility with TrafficManager and maintain routing and failover mechanisms, the best approach is:

> Deploy HAProxy instances behind a lightweight SLB, which remains the registered member in TrafficManager.



This preserves DNS-based failover while gaining routing control and flexibility with HAProxy.
