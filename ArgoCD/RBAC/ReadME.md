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



🔐 What GitOps security really looks like in Argo CD.

I built a hands-on project around Argo CD AppProjects and RBAC to simulate a real multi-team setup.

What I implemented 👇
🔹 Created separate Argo CD Projects for different teams.
🔹 Restricted:
    • which namespaces a team can deploy to.
    • which Git repositories they can use.
🔹 Deployed applications under specific projects and tested isolation.
🔹 Verified that teams cannot deploy outside their allowed scope.

📹 What the attached video shows:
I intentionally changed the destination.namespace in app.yaml(from team-a-dev → team-b-dev).
Argo CD immediately marked the application as Unknown.
The deployment was blocked before reaching Kubernetes.

Once I corrected the namespace back to team-a-dev, the app returned to Healthy & Synced.

⚠️ Interesting behavior I ran into:
One important thing I noticed:
• Argo CD enforces Project rules only when it needs to reconcile something new.
• If namespaces or workloads already exist, applications may still look Healthy and Synced, even when the Project rules are restrictive.
• Once I deleted the applications and namespaces, Argo CD was forced to re-evaluate everything — and that’s when the restrictions kicked in properly.
Lesson learned:
Stale cluster state can hide misconfigurations. Clean environments expose real GitOps behavior — which is why platform teams often validate security rules in fresh setups.

🧠 Key takeaway
• RBAC controls who can view, sync, or delete applications.
• Projects control where apps can deploy and which repos they can use.
• You need both for proper multi-team isolation in Argo CD.

#DevOps #GitOps #ArgoCD #Kubernetes #RBAC #PlatformEngineering #LearningInPublic #CloudNative #CloudComputing #Linux #Docker #Terraform #CICD