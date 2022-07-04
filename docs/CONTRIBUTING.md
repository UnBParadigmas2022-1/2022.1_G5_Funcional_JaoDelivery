# Jão Delivery

Links úteis:

 * [Readme](./../README.md)
 * [Features](#features)
 * [Issues](#issues)
 * [Pull Requests](#pull-requests)

## Desenvolvimento

 1. Clone o repositório

  ```bash
  git clone https://github.com/UnBParadigmas2022-1/2022.1_G5_Funcional_JaoDelivery.git
  ```
  
 2. Abra o projeto [Jão Delivery](https://github.com/UnBParadigmas2022-1/2022.1_G5_Funcional_JaoDelivery.git)

 3. Instale execute a aplicação com o comando:

```bash
  make run
```

 5. Crie uma nova branch a partir da main.

 6. Faça as suas alterações.

 7. Submeta suas alterações.

 7. Abra um Pull Request para a main conforme o template.

## Guia para mensagens de commits

### Formato da mensagem

Cada mensagem de commit consiste em um **cabeçalho**, um **corpo** e um **rodapé** e devem ser realizados em inglês.

### Cabeçalho

Tem um formato pré-definido, que inclui um **tipo** e um **título**:

```
<tipo>(<escopo opcional>): <título>
<corpo opcional>
<rodapé opcional>
Exemplos:
fix(integracao-erp): xxxxxxx
improve(app-toolbox): xxxxxxx
docs: docker project startup instructions
```

O **cabeçalho** é obrigatório.

Qualquer linha da mensagem do commit não pode ter mais de 100 caracteres! Assim fica mais fácil para ler no GitHub, Gitlab e outras ferramentas de git.

#### Tipo

Deve ser um dos seguintes:

* **build**: alterações que afetam o sistema de build ou dependências externas
* **static**: alterações no conteúdo de arquivos estáticos (dados .json, imagens, etc)
* **ci**: alterações em nossos arquivos e scripts de configuração de CI
* **cd**: alterações em nossos arquivos e scripts de configuração para CD
* **docs**: somente alterações na documentação
* **feat**: um novo recurso
* **fix**: uma correção de bug da aplicação
* **perf**: alteração de código que melhora o desempenho da aplicação e não altera a forma como o usuário utiliza a aplicação
* **refactor**: alteração de código, que não corrige um bug e nem altera a forma como o usuário utiliza a aplicação
* **improve**: alguma alteração de código que melhore o comportamento de um recurso
* **style**: alterações que não afetam o significado do código (espaço em branco, formatação, ponto e vírgula, etc)
* **test**: adicionando testes ausentes ou corrigindo testes existentes
* **revert**: reverter para um commit anterior

#### Título

O título contém uma descrição sucinta da mudança:

* use o imperativo, tempo presente: "muda" não "changed" nem "changes"
* não capitalize a primeira letra
* sem ponto (.) no final

### Corpo

Um corpo de mensagem de commit mais longo PODE ser fornecido após o título, fornecendo informações contextuais adicionais sobre as alterações no código.

Configure a mensagem com um wrap de 80 caracteres

Use para explicar "what" e "why" foi realizado essa modificação, ao invés de "like".

O corpo DEVE começar depois de uma linha em branco após a descrição.

### Rodapé

Um rodapé PODE ser fornecido depois de uma linha em branco após o corpo.

Caso exista um ticket no jira, criar um referência assim: `issue TP-666` ou `closes issue TP-666`

### Reverter um commit

Se o commit reverte um commit anterior, ele deve começar por `revert:`, seguido pelo cabeçalho do commit revertido. 

No corpo, ele deve dizer: `This reverses the commit <hash> .`, onde o hash é o SHA do commit sendo revertido.

### Porquê?

* Criação automatizada de CHANGELOGs
* Determinar automaticamente um aumento de versionamento semântico (com base nos tipos de commits)
* Comunicar a natureza das mudanças para colegas de equipe, o público e outras partes interessadas de forma padronizada
* Disparar processos de build e deploy
* Facilitar a contribuição de outras pessoas em seus projetos, permitindo que eles explorem um histórico de commits mais estruturado e com melhor rastreabilidade

## Política de Branchs

  1. Esse projeto utiliza o padrão gitflow. Siga as orientações descritas [aqui](https://www.atlassian.com/br/git/tutorials/comparing-workflows/gitflow-workflow).
  
## Features

Para a criação de novas features, deve-se seguir os seguintes passos:

  1. Definir uma issue com um dos templates pré-determinados
  2. Anexar _labels_ relacionadas ao tipo de issue criada
  3. Após aprovação, associar a issue para o desenvolvedor que irá realizá-la
  4. Submeter pull request das alterações realizadas

## Issues

As Issues e Bugs encontrados devem ser reportados baseados nos templates pré determinados encontrados nos links abaixo:

* [Bugs](./../.github/ISSUE_TEMPLATE/bug.md)
* [Issues](./../.github/ISSUE_TEMPLATE/issue.md)

## Pull Requests

A submissão de Pull Requests devem ser feitas através da especificação encontrada [aqui](./../.github/PULL_REQUEST_TEMPLATE.md)

## Referências

> [Conventional Commits](https://www.conventionalcommits.org/pt-br/)
> [Git Flow](https://www.atlassian.com/br/git/tutorials/comparing-workflows/gitflow-workflow)