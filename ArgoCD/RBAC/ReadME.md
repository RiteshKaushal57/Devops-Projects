## Key Learning #1 (from Project 5 – AppProjects & Isolation)
Argo CD enforces Project rules only when it has something new to reconcile.
Existing cluster state (old namespaces or workloads) can hide enforcement until the environment is reset.

**What this means in simple terms:**  
- Argo CD does not constantly re-validate everything
- If resources already exist and nothing new needs to be created:
    1. Project rules may not visibly trigger
    2. Apps can appear Healthy / Synced
- Once you delete Applications and namespaces, Argo CD is forced to:
    1. Re-evaluate the Application
    2. Re-check Project rules
    3.cBlock invalid destinations before Kubernetes is called

**Why this matters in real life:**  
- Stale cluster state can give a false sense of security
- Clean environments expose true GitOps behavior
- Platform teams often test RBAC and Projects in fresh clusters for this reason

*This is a very real production lesson, not a lab-only thing.*

What RBAC controls (important distinction)

RBAC in Argo CD controls:

👀 Who can see applications

🔄 Who can sync applications

🗑️ Who can delete applications

⚙️ Who can manage Projects, clusters, and repos

RBAC does NOT control:

namespaces

Git paths
(those are handled by Projects)



