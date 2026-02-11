resource "null_resource" "ansible_trigger" {
  # This ensures Ansible only runs AFTER the EKS cluster is fully ready
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region us-east-1 --name online-boutique-cluster
      ansible-playbook -i ../ansible/inventory.ini ../ansible/main.yml
    EOT
  }

  # This trigger makes it re-run if the cluster ID changes
  triggers = {
    cluster_id = module.eks.cluster_id
  }
}