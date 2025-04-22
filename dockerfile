# Etapa 1: Build da aplicação React
# Usando a imagem base oficial do Node.js (versão 18 no Alpine, que é mais leve)
FROM node:18-alpine AS builder

# Define o diretório de trabalho no container
WORKDIR /app

# Copia os arquivos de dependências (package.json e package-lock.json) para o diretório de trabalho
COPY package*.json ./

# Instala as dependências definidas no package.json
RUN npm install

# Copia o restante do código da aplicação para o diretório de trabalho
COPY . .

# Faz o build da aplicação React, criando os arquivos estáticos na pasta 'build'
RUN npm run build

# Etapa 2: Container final, que serve a aplicação buildada
# Usamos a mesma imagem base para garantir que o ambiente final seja leve e eficiente
FROM node:18-alpine

# Define o diretório de trabalho no container
WORKDIR /app

# Instala o pacote global 'serve', que serve a aplicação React de maneira otimizada
RUN npm install -g serve

# Copia os arquivos da pasta 'build' gerados na etapa anterior para o container final
COPY --from=builder /app/build ./build

# Expõe a porta 80 para que a aplicação possa ser acessada externamente
EXPOSE 80

# Comando para iniciar o servidor 'serve', que serve a aplicação React na porta 80
CMD ["serve", "-s", "build", "-l", "80"]

# Comandos para construção e execução do Docker

# Comando para construir a imagem Docker:
# docker build -t tavos/meu-app:latest .

# Comando para rodar o container Docker:
# docker run -d -p 8080:80 -v dados-app:/dados --name meu-app-container tavos/meu-app:latest

#Questão 4
#Persistência de Dados: Volumes mantêm os dados fora do container, evitando que sejam apagados quando o container é removido.

#Facilidade de Backup e Recuperação: Facilita o backup dos dados, pois ficam armazenados de forma persistente no sistema de arquivos do host.

#Compartilhamento entre Containers: Permite que múltiplos containers acessem os mesmos dados.

#Ao rodar um banco de dados como o MySQL, você pode usar volumes para garantir que os dados persistam:
#docker run -d -v dados-banco:/var/lib/mysql --name banco-container mysql:latest

#Isso garante que os dados do banco não se percam se o container for removido.

#Questão 5
#a) docker login
#b) docker push tavos/meu-app:latest

#Questão 6
#docker-compose up -d

#Questão 7
#GitHub Actions automatiza o build e o push da imagem Docker.

#Sempre que você faz push no repositório, ele:

#Builda a imagem com o código atualizado.

#Faz push automático para o Docker Hub.

#Vantagens:
#Evita erro humano.

#Garante que a imagem esteja sempre atualizada.

#Automatiza o processo, economizando tempo.
