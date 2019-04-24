provider "github" {
 token        = "${var.github_token}"
}
resource "github_repository" "terraform_repo" {
  name              = "terraform-repo3"
  description       = "my terraform repo"
  auto_init         = true
}
