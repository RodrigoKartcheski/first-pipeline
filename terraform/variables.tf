# Arquivo onde as variáveis são declaradas.

# Alterar manualmente as variaveis no arquivo backend.tf e criar os bucket para as DAGs e terraform manualmente

variable "PROJECT" {
  # O projeto GCP
  description = "O projeto onde os recursos serão criados"
  type        = string
}

variable "REGION" {
  # A região do projeto GCP
  description = "A região onde os recursos serão criados"
  type        = string
}

variable "ZONE" {
  # A zona da região do projeto GCP
  description = "A zona específica para os recursos"
  type        = string
}

variable "GIT_COMMITISH" {
  type    = string
}

variable "RP_COMPULSORIO_TRUSTED_ANALISE_PROVISAO" {
  # O repositorio do dataform camada Trusted nas variaveis do Composer 
  type    = string
}

variable "WS_COMPULSORIO_TRUSTED_ANALISE_PROVISAO" {
  # O Workspace do repositorio do dataform camada Trusted nas variaveis do Composer 
  type    = string
}

variable "RP_COMPULSORIO_REFINED_ANALISE_PROVISAO" {
  # O repositorio do dataform camada Refined nas variaveis do Composer 
  type    = string
}

variable "WS_COMPULSORIO_REFINED_ANALISE_PROVISAO" {
  # O Workspace do repositorio do dataform camada Refined nas variaveis do Composer 
  type    = string
}

variable "DS_COMPULSORIO_RAW_ANALISE_PROVISAO" {
  # O Dataset do bigquery usado para monitorar atualização especifica do Composer 
  type    = string
}

variable "TB_MODIFIED_COMPULSORIO_RAW_ANALISE_PROVISAO" {
  # A tabela do Dataset do bigquery usado para monitorar atualização especifica do Composer
  type    = string
}

variable "COMPOSER_NAME" {
  description = "O nome do ambiente do composer"
  type        = string
}

// em desuso
variable "COMPOSER_SA_ID" {
  description = "Nome do service account do Composer"
  type        = string
}

variable "BUCKET_OBJECT_PREFIX" {
  description = "Nome do bucket para o Cloud Composer (DAGs e consultas)"
  type        = string
}

# Programador (Scheduler)
variable "SCHEDULER_CPU" {
  description = "Número de vCPUs para o programador"
  type        = number
  default     = 0.5
}

variable "SCHEDULER_MEMORY" {
  description = "Quantidade de memória (em GB) para o programador"
  type        = number
  default     = 2
}

variable "SCHEDULER_STORAGE" {
  description = "Espaço de armazenamento (em GB) para o programador"
  type        = number
  default     = 1
}

variable "SCHEDULER_COUNT" {
  description = "Número de instâncias do programador"
  type        = number
  default     = 1
}

# Acionador (Triggerer)
variable "TRIGGERER_CPU" {
  description = "Número de vCPUs para o acionador"
  type        = number
  default     = 0.5
}

variable "TRIGGERER_MEMORY" {
  description = "Quantidade de memória (em GB) para o acionador"
  type        = number
  default     = 1
}

variable "TRIGGERER_STORAGE" {
  description = "Espaço de armazenamento (em GB) para o acionador"
  type        = number
  default     = 1
}

variable "TRIGGERER_COUNT" {
  description = "Número de instâncias do acionador"
  type        = number
  default     = 1
}

# Servidor Web (Web Server)
variable "WEB_SERVER_CPU" {
  description = "Número de vCPUs para o servidor web"
  type        = number
  default     = 0.5
}

variable "WEB_SERVER_MEMORY" {
  description = "Quantidade de memória (em GB) para o servidor web"
  type        = number
  default     = 2
}

variable "WEB_SERVER_STORAGE" {
  description = "Espaço de armazenamento (em GB) para o servidor web"
  type        = number
  default     = 1
}

# Workers
variable "WORKER_CPU" {
  description = "Número de vCPUs para os workers"
  type        = number
  default     = 0.5
}

variable "WORKER_MEMORY" {
  description = "Quantidade de memória (em GB) para os workers"
  type        = number
  default     = 2
}

variable "WORKER_STORAGE" {
  description = "Espaço de armazenamento (em GB) para os workers"
  type        = number
  default     = 10
}

variable "WORKERS_MIN" {
  description = "Número mínimo de workers"
  type        = number
  default     = 1
}

variable "WORKERS_MAX" {
  description = "Número máximo de workers"
  type        = number
  default     = 3
}

variable "ENVIRONMENT_SIZE" {
  type    = string
  default = "ENVIRONMENT_SIZE_SMALL" # Escolha o valor apropriado
}