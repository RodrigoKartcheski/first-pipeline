resource "google_project_service" "composer_api" {
  provider = google-beta
  project  = var.PROJECT
  service  = "composer.googleapis.com"
  // Disabling Cloud Composer API might irreversibly break all other
  // environments in your project.
  disable_on_destroy = false
  // this flag is introduced in 5.39.0 version of Terraform. If set to true it will
  //prevent you from disabling composer_api through Terraform if any environment was
  //there in the last 30 days
  check_if_service_has_usage_on_destroy = true
}

resource "google_composer_environment" "composer_environment" {
  provider = google-beta
  name     = var.COMPOSER_NAME

  storage_config {
    bucket = "${var.BUCKET_OBJECT_PREFIX}-${var.PROJECT}-${var.REGION}-composer" // ex cs-my-project-us-east1-composer
  }

  config {
    // Configuração de ambientes
    workloads_config {
      scheduler {
        cpu        = var.SCHEDULER_CPU
        memory_gb  = var.SCHEDULER_MEMORY
        storage_gb = var.SCHEDULER_STORAGE
        count      = var.SCHEDULER_COUNT
      }
      triggerer {
        count     = var.TRIGGERER_COUNT
        cpu       = var.TRIGGERER_CPU
        memory_gb = var.TRIGGERER_MEMORY
      }
      web_server {
        cpu        = var.WEB_SERVER_CPU
        memory_gb  = var.WEB_SERVER_MEMORY
        storage_gb = var.WEB_SERVER_STORAGE
      }
      worker {
        cpu        = var.WORKER_CPU
        memory_gb  = var.WORKER_MEMORY
        storage_gb = var.WORKER_STORAGE
        min_count  = var.WORKERS_MIN
        max_count  = var.WORKERS_MAX
      }
    }

    environment_size = var.ENVIRONMENT_SIZE

    software_config {
      image_version = "composer-3-airflow-2.9.3-build.3"

    env_variables = {
        GIT_COMMITISH = var.GIT_COMMITISH
        PROJ_ID = var.PROJECT
        REGION = var.REGION
        RP_COMPULSORIO_TRUSTED_ANALISE_PROVISAO = var.RP_COMPULSORIO_TRUSTED_ANALISE_PROVISAO
        WS_COMPULSORIO_TRUSTED_ANALISE_PROVISAO = var.WS_COMPULSORIO_TRUSTED_ANALISE_PROVISAO
        RP_COMPULSORIO_REFINED_ANALISE_PROVISAO = var.RP_COMPULSORIO_REFINED_ANALISE_PROVISAO
        WS_COMPULSORIO_REFINED_ANALISE_PROVISAO = var.WS_COMPULSORIO_REFINED_ANALISE_PROVISAO
        DS_COMPULSORIO_RAW_ANALISE_PROVISAO = var.DS_COMPULSORIO_RAW_ANALISE_PROVISAO
        TB_MODIFIED_COMPULSORIO_RAW_ANALISE_PROVISAO = var.TB_MODIFIED_COMPULSORIO_RAW_ANALISE_PROVISAO
      }

      # Adicionando o pacote PyPI para o Cloud Composer
      //pypi_packages = {
      //  "requests" = "==2.26.0" # Pacote e versão para instalar
      //}
    }

    node_config {
      service_account = google_service_account.custom_service_account.email
    }
  }
  depends_on = [
    google_service_account.custom_service_account,
    google_project_iam_member.custom_service_account_composer_worker,
    google_project_iam_member.custom_service_account_composer_admin,
    google_project_iam_member.custom_service_account_composer_service_agent,
    google_project_iam_member.custom_service_account_bigquery_editor,
    google_project_iam_member.custom_service_account_dataform_editor,
    google_project_iam_member.custom_service_account_cloudfunctions_invoker
  ]
}
