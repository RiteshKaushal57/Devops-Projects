𝗗𝗲𝗽𝗹𝗼𝘆𝗶𝗻𝗴 𝗺𝘂𝗹𝘁𝗶𝗽𝗹𝗲 𝗮𝗽𝗽𝘀 𝘁𝗵𝗲 𝗿𝗶𝗴𝗵𝘁 𝘄𝗮𝘆 — 𝗔𝗿𝗴𝗼 𝗖𝗗 𝗔𝗽𝗽-𝗼𝗳-𝗔𝗽𝗽𝘀 𝘄𝗶𝘁𝗵 𝗦𝘆𝗻𝗰 𝗪𝗮𝘃𝗲𝘀 🚀

After working with individual Argo CD applications, I wanted to understand how multiple services are managed together in real production setups.

So I built a hands-on project using the App-of-Apps pattern in Argo CD and combined it with Sync Waves to control deployment order — all driven purely from Git.

Here’s what I implemented 👇
🔹 Used the App-of-Apps pattern to manage frontend, backend, and database from a single root application.
🔹 Structured the repo the way real teams do (root app → child apps → service manifests).
🔹 Applied Sync Waves to control deployment order:
  • Database first
  • Backend next
  • Frontend last
🔹 Let Argo CD handle creation, ordering, and reconciliation automatically.

⚠️ Problems I faced (and what I learned)
🔸 Some applications stayed in an Unknown state even though nothing looked broken.
🔸 Kubernetes showed Healthy status when no resources were being deployed, which was confusing at first.
🔸 I learned that Argo CD does not validate namespaces or health until it actually applies resources.
🔸 Once I added real workloads (Deployments / StatefulSets), the missing namespace and sync issues became visible.
🔸 Enabling CreateNamespace=true and fixing the application structure resolved the issue cleanly.

💡 Key takeaways
• An application can look healthy even if its namespace doesn’t exist — until resources are applied.
• GitOps controllers react only when there is something to reconcile.
• Sync Waves control order of sync, not application creation.
• Git remains the single source of truth at all times.


#DevOps #GitOps #ArgoCD #Kubernetes #LearningInPublic #DevOpsEngineer #CloudComputing #AWS #Docker #Linux #CICD #Terraform #Ansible #Jenkins