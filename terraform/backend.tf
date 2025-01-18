terraform {
  backend "gcs" {
    bucket = "cs-dataplex-experience-6133-us-east1-terraform" # ex "cs_projeto_us_east1_terraform"  Substitua pelo nome do bucket
    prefix = "terraform/state"                      # Organiza os arquivos de estado dentro do bucket
  }
}

