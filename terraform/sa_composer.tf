resource "random_integer" "random_number" {
  min = 10000000 # 8 dígitos
  max = 99999999 # 8 dígitos
}

# Conta de serviço personalizada com número aleatório no início e sufixo no final
resource "google_service_account" "custom_service_account" {
  provider     = google-beta
  account_id   = "gcp-${random_integer.random_number.result}-composer-sa" # Número aleatório seguido de "-composer-sa"
  display_name = "Composer Service Account gcp-${random_integer.random_number.result}-composer-sa"
}

output "composer_service_account_name" {
  value = google_service_account.custom_service_account.email
}

# Atribuição de papel para o Cloud Composer (necessário para o Composer operar)
resource "google_project_iam_member" "custom_service_account_composer_worker" {
  provider = google-beta
  project  = var.PROJECT
  //member   = "serviceAccount:experience-6133-composer-sa@${var.PROJECT}.iam.gserviceaccount.com"
  member = "serviceAccount:${google_service_account.custom_service_account.email}" # Usando a conta de serviço criada
  role   = "roles/composer.worker"                                                 # Papel necessário para ambientes do Composer
}

# Atribuição de papel para o Cloud Composer v2 (extensão do agente de serviço)
resource "google_project_iam_member" "custom_service_account_composer_admin" {
  provider = google-beta
  project  = var.PROJECT
  member   = "serviceAccount:${google_service_account.custom_service_account.email}"
  role     = "roles/composer.admin" # Papel necessário para interagir com a API do Cloud Composer v2
}

# Atribuição de papel para o Cloud Composer v2 Extension Service Agent
resource "google_project_iam_member" "custom_service_account_composer_service_agent" {
  provider = google-beta
  project  = var.PROJECT
  member   = "serviceAccount:${google_service_account.custom_service_account.email}"
  role     = "roles/composer.ServiceAgentV2Ext" # Papel adicional necessário para a extensão do Cloud Composer v2
}

# Atribuição de papel para BigQuery (necessário para o Cloud Composer operar com BigQuery)
resource "google_project_iam_member" "custom_service_account_bigquery_editor" {
  provider = google-beta
  project  = var.PROJECT
  member   = "serviceAccount:${google_service_account.custom_service_account.email}"
  role     = "roles/bigquery.dataEditor" # Permissões para ler e escrever no BigQuery
}

# Atribuição de papel para Dataform Editor
resource "google_project_iam_member" "custom_service_account_dataform_editor" {
  provider = google-beta
  project  = var.PROJECT
  member   = "serviceAccount:${google_service_account.custom_service_account.email}"
  role     = "roles/dataform.editor" # Permissões para editar e gerenciar recursos no Dataform
}

# Atribuição de papel para o Cloud Functions (necessário para invocar funções)
resource "google_project_iam_member" "custom_service_account_cloudfunctions_invoker" {

  provider = google-beta
  project  = var.PROJECT
  member   = "serviceAccount:${google_service_account.custom_service_account.email}"
  role     = "roles/cloudfunctions.invoker" # Permissões para invocar funções no Cloud Functions
}
