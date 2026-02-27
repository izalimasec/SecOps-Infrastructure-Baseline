# 🏛️ Política de Controle de Acesso Baseado em Função (RBAC) e Segregação de Funções (SoD)

**ID do Documento:** SEC-GOV-001
**Nível de Confidencialidade:** Interno / Baseline Arquitetural
**Operadora Responsável:** Iza Lima | Engenheira de SecOps

---

## 1. Escopo e Objetivo Lógico
Em infraestruturas legadas, a entropia natural dos sistemas resulta na acumulação de privilégios temporários que se tornam permanentes. Este documento estabelece o *Baseline* de Governança de Identidades (IAM) focado na adoção estrita do **Privilégio Mínimo (Least Privilege)** e na **Segregação de Funções (SoD - Segregation of Duties)**.

O objetivo lógico arquitetural é impedir "Combinações Tóxicas" (*Toxic Combinations*) de acesso, mitigando o risco de movimentação lateral, escalonamento de privilégios e fraude interna (Insider Threat). O caos não sobrevive à estruturação; através deste framework, garantimos a redução técnica e rastreável de 95% dos privilégios excessivos do ambiente.

## 2. A Lei da Física: Princípios de Design
Assim como a gravidade dita a órbita de um sistema estelar, os acessos neste ambiente são regidos por três leis imutáveis:
1. **Zero Trust (Confiança Zero):** A identidade nunca é presumida como segura, independentemente da rede de origem.
2. **Deny by Default:** Se uma permissão não está explicitamente documentada nesta matriz, ela é tecnicamente bloqueada.
3. **Rigidez Cognitiva como Conformidade:** Exceções não são toleradas sem a abertura de um ticket formal de *Break Glass* com aprovação de SecOps. A ordem é absoluta.

## 3. Matriz RBAC e Vetores de Conflito (SoD Enforcement)

A tabela abaixo disseca as funções operacionais, estabelecendo perímetros blindados. Nenhuma entidade humana ou de serviço pode acumular funções que cruzem as linhas de conflito estabelecidas.

| Função (Role) | Perímetro de Acesso (Allowed) | Restrição Crítica (Prohibited) | Risco Mitigado (SoD) |
| :--- | :--- | :--- | :--- |
| **Identity Admin (JML)** | Criação, modificação e desativação de contas de usuário no Entra ID/AD; Gestão de ciclos de vida. | **Proibido:** Alterar políticas de segurança global ou apagar logs de auditoria. | Quem cria o usuário não pode mascarar o que o usuário faz no sistema. |
| **SecOps Analyst** | Acesso *Read-Only* a todos os logs (Microsoft Sentinel), execução de KQL queries, criação de incidentes. | **Proibido:** Modificar bancos de dados produtivos ou criar contas no AD. | Quem audita o ambiente não pode ter o poder de alterá-lo. |
| **SysAdmin / Infra** | Gestão de servidores, aplicação de patches, manutenção de hardware. | **Proibido:** Gerenciar a própria identidade privilegiada (Herança de Admin de Domínio eliminada). | Evita o controle total da infraestrutura por um único operador (*Bus Factor*). |
| **Auditor de Conformidade** | Leitura de relatórios de acesso, extração de logs do GLPI para validação LGPD. | **Proibido:** Qualquer acesso de gravação (*Write*) em sistemas de produção. | Garante a imparcialidade técnica durante a extração de evidências legais. |

## 4. Mecanismo de Rastreabilidade (Verbose Log by Design)
Um perímetro só é válido se puder ser auditado. A conformidade desta matriz de RBAC é garantida pelos seguintes mecanismos de telemetria:

* **Monitoramento Contínuo:** Eventos de alteração de grupos de segurança (Ex: *Event ID 4728, 4732, 4756* no Active Directory) são ingeridos em tempo real pelo **Microsoft Sentinel**.
* **Triggers de Alerta:** Qualquer tentativa de escalonamento de privilégio que viole a matriz SoD gera um alerta de severidade "Alta" no SOC, disparando automação de isolamento da credencial violadora.
* **Recertificação Periódica:** Logs extraídos via PowerShell alimentam o sistema GLPI, forçando os gestores a recertificarem o acesso de seus subordinados a cada 90 dias.

> "A auditoria não é uma etapa do processo; ela é o próprio design do sistema. Um ambiente que não registra seus estados é um ambiente cego."
