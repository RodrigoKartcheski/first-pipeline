# Documentação do Projeto Terraform

Este projeto utiliza o Terraform para provisionar recursos na Google Cloud Platform. A configuração inclui a definição de providers, variáveis e recursos essenciais para o gerenciamento da infraestrutura.

├── main.tf        # Arquivo principal do Terraform
├── variables.tf   # Arquivo de variáveis do Terraform
├── README.md      # Documentação do projeto
└── outputs.tf     # Arquivo de saídas do Terraform

# Antes de começar
Esta versão do Terraform exige que sejam criados 2 bucket manualmente
 > cs-dataplex-experience-6133-us-east1-composer 
 > cs-dataplex-experience-6133-us-east1-terraform
E importante ler o README e configurar o arquivo variable.tf
Recomendado deixar as variaveis que os usuarios pode editar no arquivo .tvars e as outras variaveis deixar setadas no arquivo variable.tf

# Arquivo principal (main.tf)

## 1. Definição dos Providers
O bloco terraform é responsável por definir os providers necessários para o gerenciamento da infraestrutura. No exemplo fornecido, o provider utilizado é o google, que permite que o Terraform interaja com os recursos do Google Cloud.

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

Explicação:
 > required_providers: Este bloco lista os providers necessários para o Terraform. No caso, o provider google é utilizado para interagir com os recursos do Google Cloud.
 > source: Especifica a origem do provider, que neste caso é o hashicorp/google.
 > version: Define a versão do provider. Aqui, a versão selecionada é a 3.5.0.

## 2. Definição do Provider google-beta
O bloco provider configura o provider do Google Cloud, especificando a versão google-beta, que permite o uso de recursos em versão beta do Google Cloud.

provider "google-beta" {
  project = var.PROJECT
  region  = var.REGION
}

Explicação:
 > provider "google-beta": Configura o provider google-beta que é utilizado para acessar e provisionar recursos que estão na versão beta do Google Cloud.
 > project: O ID do projeto no Google Cloud. O valor é fornecido pela variável var.PROJECT.
 > region: A região onde os recursos serão provisionados. O valor é fornecido pela variável var.REGION.

## 3. Utilização de Variáveis
As variáveis var.PROJECT e var.REGION são usadas para definir o ID do projeto e a região do Google Cloud onde os recursos serão provisionados. Essas variáveis são definidas em um arquivo separado, como variables.tf, ou podem ser passadas como parâmetros ao aplicar o Terraform.

Exemplo de arquivo variables.tf:
variable "PROJECT" {
  description = "ID do projeto no Google Cloud"
  type        = string
}

variable "REGION" {
  description = "Região onde os recursos serão provisionados"
  type        = string
}

# Como Executar
terraform init
terraform init -migrate-state "no pirmeiro init para ativar o beckend.tf"
terraform plan
terraform validade
terraform fmt
terraform apply
terraform destroy


# Como Funcionam as Variáveis no Terraform (variable.tf)
No Terraform, variáveis são utilizadas para tornar as configurações mais dinâmicas e reutilizáveis. Elas permitem que você defina valores que podem ser facilmente alterados sem a necessidade de modificar diretamente os arquivos principais de configuração.

## Declaração de Variáveis
As variáveis são declaradas em arquivos .tf (como variables.tf) usando o bloco variable. Cada variável tem:
 > Descrição: Uma explicação sobre o que a variável representa.
 > Tipo: Define o tipo de dado que a variável aceita (por exemplo, string, number).
 > Valor Padrão: Um valor que será utilizado se nenhum valor for fornecido explicitamente. Se não houver valor padrão, a variável precisará ser configurada de outra forma.

Exemplo de declaração de uma variável:
variable "REGION" {
  description = "A região onde os recursos serão criados"
  type        = string
  default     = "us-east1"  # Valor padrão
}

## Como Usar Variáveis
Uma vez declarada, a variável pode ser usada em qualquer parte da configuração do Terraform (por exemplo, em main.tf ou outputs.tf), substituindo valores fixos por valores dinâmicos.

Exemplo de uso da variável:
provider "google" {
  project = var.PROJECT  # Referência à variável PROJECT
  region  = var.REGION   # Referência à variável REGION
}

## Definindo Variáveis na Linha de Comando
Você pode sobrescrever o valor de uma variável fornecendo-o diretamente ao rodar o comando terraform apply:
 > terraform apply -var "PROJECT=my-project-id" -var "REGION=us-central1"

Arquivo de Variáveis (variables.tf)
É uma prática comum armazenar todas as variáveis em um arquivo específico (variables.tf). Esse arquivo facilita a organização e a manutenção das variáveis em projetos maiores.

## Exemplos de Tipos de Variáveis
 > string: Usado para textos, como nomes de recursos ou IDs de projetos.
 > number: Usado para valores numéricos, como quantidades ou tamanhos.
 > bool: Usado para valores booleanos (true ou false).
 > list: Usado para listas de valores.
 > map: Usado para pares de chave/valor.

# Explicação do Código Terraform (composer3.tf)
O código define a criação de um ambiente Cloud Composer no Google Cloud, incluindo a criação de uma conta de serviço personalizada e a atribuição de permissões necessárias para o funcionamento do Composer e de outros serviços.

## 1. Geração de Número Aleatório
A primeira parte do código gera um número aleatório de 8 dígitos para ser usado na criação da conta de serviço:

hcl
Copiar código
resource "random_integer" "random_number" {
  min = 10000000
  max = 99999999
}

## 2. Criação de Conta de Serviço Personalizada
Uma conta de serviço é criada com um ID dinâmico usando o número aleatório gerado anteriormente. O nome da conta de serviço inclui esse número:

hcl
Copiar código
resource "google_service_account" "custom_service_account" {
  account_id   = "gcp-${random_integer.random_number.result}-composer-sa"
  display_name = "Composer Service Account ${random_integer.random_number.result}"
}

## 3. Atribuição de Papéis
O código atribui vários papéis à conta de serviço para permitir que ela interaja com diferentes serviços:

Cloud Composer: Permissões para trabalhar com ambientes do Composer.
hcl
Copiar código
resource "google_project_iam_member" "custom_service_account_composer_worker" {
  member = "serviceAccount:${google_service_account.custom_service_account.email}"
  role   = "roles/composer.worker"
}
Cloud Composer v2: Permissões para interagir com a API do Composer v2.
hcl
Copiar código
resource "google_project_iam_member" "custom_service_account_composer_admin" {
  member = "serviceAccount:${google_service_account.custom_service_account.email}"
  role   = "roles/composer.admin"
}
BigQuery: Permissões para ler e escrever dados no BigQuery.
hcl
Copiar código
resource "google_project_iam_member" "custom_service_account_bigquery_editor" {
  member = "serviceAccount:${google_service_account.custom_service_account.email}"
  role   = "roles/bigquery.dataEditor"
}
Cloud Functions: Permissões para invocar funções no Cloud Functions.
hcl
Copiar código
resource "google_project_iam_member" "custom_service_account_cloudfunctions_invoker" {
  member = "serviceAccount:${google_service_account.custom_service_account.email}"
  role   = "roles/cloudfunctions.invoker"
}
## 4. Habilitação da API do Composer
A API do Cloud Composer é habilitada no projeto para permitir o uso do serviço:

hcl
Copiar código
resource "google_project_service" "composer_api" {
  service = "composer.googleapis.com"
}

## 5. Criação do Ambiente Cloud Composer
Finalmente, o ambiente do Cloud Composer é configurado, incluindo a definição de recursos como CPU, memória e armazenamento para o programador, acionador, servidor web e workers. A configuração também define a versão do Airflow a ser utilizada:

hcl
Copiar código
resource "google_composer_environment" "example_environment" {
  name = "example-environment"
  storage_config {
    bucket = "cc_${var.PROJECT}_${var.REGION}"
  }
  config {
    workloads_config {
      scheduler {
        cpu        = var.SCHEDULER_CPU
        memory_gb  = var.SCHEDULER_MEMORY
        storage_gb = var.SCHEDULER_STORAGE
        count      = var.SCHEDULER_COUNT
      }
      # Definição de recursos para triggerer, web_server e worker...
    }
  }
}

# Arquivos com variaveis especificas por projeto
backend.tf
variables.tf
terraform.tfvars

## Resumo
O código cria um ambiente do Cloud Composer no Google Cloud, define uma conta de serviço personalizada com um número aleatório, e atribui as permissões necessárias para que essa conta possa interagir com o Composer, BigQuery e Cloud Functions. A configuração inclui ainda a habilitação da API e o ajuste de recursos do ambiente.

# Fontes
https://cloud.google.com/composer/docs/composer-3/access-control?hl=pt-br
https://cloud.google.com/composer/docs/composer-3/terraform-create-environments?hl=pt-br
https://cloud.google.com/composer/docs/composer-3/install-python-dependencies?hl=pt-br
