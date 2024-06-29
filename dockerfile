# IMAGEM do SDK para compilar aplicação
FROM mcr.microsoft.com/dotnet/sdk:8.0 as build-env
#cd /App
WORKDIR /App

# Copiar os arquivos do diretório atual para o WORKDIR
COPY . ./

#cd /App/MinhaAPI
WORKDIR /App/MinhaAPI

# Verifica as dependências do projeto (pacotes extras) e instala
RUN dotnet restore

# Compilar o código e criar o código de output na pasta de build 
# Na pasta /bin, cria os executáveis, .dll, etc.
RUN dotnet build

# Esse comando também faz o build, porém prepara a solução inteira para deploy 
# Modo Debug e Release
RUN dotnet publish -c Release -o out


# Após compilar o projeto, agora só precisa da imagem para fazer o RUN (runtime)

# IMAGEM do RUNTIME para só rodar a aplicação (imagem mais leve, melhor para produção)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 as run-env

#cd /App
WORKDIR /App

# Copiar os arquivos do diretório criado anteriormente com os artefatos para o WORKDIR
COPY --from=build-env /App/MinhaAPI/out .

# Comandos para gatilho da aplicação (inicializar)
ENTRYPOINT [ "dotnet", "Dotnet.Docker.dll" ]