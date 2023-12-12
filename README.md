# 🚗 Aplicativo_UberLand 

## 📃 Sobre

Este projeto foi desenvolvido na disciplina Sistema de Banco de Dados. O trabalho foi realizado pelos estudantes Marcus Vinícius Almeida Florêncio, Cauã Pereira Neres, Hendrik Abdalla Hermann e Pedro Henrique de Oliveira.

No repositório **Aplicativo_UberLand**, na pasta **Código**, encontram-se os scripts de criação do banco de dados, de preenchimento do banco e também um arquivo contendo as consultas, stored procedures e a trigger. Além disso, é possível encontrar no repositório o Diagrama de Entidade Relacionamento, o Modelo Relacional, as documentações completas da Parte 1 e 2 do trabalho, e o arquivo **Trabalho SBD.docx**. Nele, encontram-se os requisitos completos do projeto.

## 📖 Contexto
Uberlândia está na lista das cidades mineiras que mais possuem casos de dengue. Atualmente, foram constatados mais de 127 mil casos e 70 mortes de dengue no município.

Algumas atitudes têm sido tomadas pela Prefeitura Municipal de Uberlândia, como a utilização de carros de fumacê, que objetivam eliminar os mosquitos. Apesar disso, a doença retorna anualmente. 

O caminhão do fumacê é um veículo que aplica inseticidas para combater o mosquito Aedes aegypti. O uso do fumacê é uma medida aplicada para controlar a dengue, mas é importante que o caminhão seja utilizado de forma eficiente para que o combate seja eficaz. 

Um dos principais problemas do fumacê é a sua eficiência limitada. Como o fumacê é aplicado na forma de fumaça, ele pode não atingir todos os mosquitos adultos, especialmente aqueles que estão abrigados em locais fechados ou que estão em movimento.


## 🎯 Objetivo
Otimizar o combate à dengue na cidade de Uberlândia, encontrando o caminho mais curto para que o caminhão do fumacê percorra todas as ruas contaminadas da cidade.

## 🧠 Modelagem
- As ruas são modeladas como arestas do grafo;
- Os vértices podem ou não serem focos de dengue;
- O peso de cada aresta representa o comprimento das ruas.

## 💻 Visão Geral do Programa
Os inputs são:
- quantidade de vértices
- as ruas juntamente com suas distâncias
- vértices contaminados
- local de início do carro do fumacê

O output gera:
- Menor caminho
- Distância total

Para encontrar o menor caminho foi o utilizado o algoritmo Dijkstra com fila de prioridade.
